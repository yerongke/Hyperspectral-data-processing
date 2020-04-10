function predModel=plspredict(Xpred,Model,no_of_lv,Yref)

%  plspredict predicts reference values for new X data
%
%  Input:
%  Xpred: test data 
%  Model: output from plsmodel.m
%  no_of_lv is the number of PLS components to use in prediction
%  Yref: optional, reference values (if available)
%
%  Output:
%  predModel is a structure array containing all model information
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  predModel=plspredict(Xpred,Model,no_of_lv,Yref);

if nargin==0
   disp(' ')
   disp(' predModel=plspredict(Xpred,Model,no_of_lv,Yref);')
   disp(' ')
   disp(' Example:')
   disp(' predModel=plspredict(Xpred,Model,8,Yref);')
   disp(' ')
   disp(' predModel=plspredict(Xpred,Model,8);')
   disp(' ')
   return
end

% Error checks
if ~ismember(Model.type,{'PLS'})
    disp(' ')
    disp('This function only works with output from plsmodel.m')
    disp(' ')
    predModel=[];
    return
end
% End error checks

predModel.type='PLSprediction';

if isfield(Model,'windowsize') % If oneModel is based on mwModel
selected_vars=Model.selected_vars;    
else
  selected_vars=[];
  for i=1:max(size(Model.selected_intervals))
     temp=Model.allint(Model.selected_intervals(i),2):Model.allint(Model.selected_intervals(i),3);
     selected_vars=[selected_vars temp];
  end
end
predModel.Xpred=Xpred(:,selected_vars); % From input

predModel.no_of_lv=no_of_lv; % From input

if nargin==4
    predModel.Yref=Yref; % From input
else
    predModel.Yref=[];
end

% Transformations - X
if strcmp(lower(Model.prepro_method),'mean')
   [Xtrans_cal,mx]=mncn(Model.rawX(:,selected_vars));
   Xpred=scalenew(predModel.Xpred,mx);
elseif strcmp(lower(Model.prepro_method),'auto')
   [Xtrans_cal,mx,stdx]=auto(Model.rawX(:,selected_vars));
   Xpred=scalenew(predModel.Xpred,mx,stdx);
elseif strcmp(lower(Model.prepro_method),'mscmean')
   [Xtrans_cal,Xmean_cal]=msc(Model.rawX(:,selected_vars));
   [Xtrans_cal,mx]=mncn(Xtrans_cal);
   Xpred=msc_pre(predModel.Xpred,Xmean_cal);
   Xpred=scalenew(predModel.Xpred,mx);
elseif strcmp(lower(Model.prepro_method),'mscauto')
   [Xtrans_cal,Xmean_cal]=msc(Model.rawX(:,selected_vars));
   [Xtrans_cal,mx,stdx]=auto(Xtrans_cal);
   Xpred=msc_pre(predModel.Xpred,Xmean_cal);
   Xpred=scalenew(predModel.Xpred,mx,stdx);
elseif strcmp(lower(Model.prepro_method),'none')
   % To secure that no centering/scaling is OK    
end

Ypred = pls_pre(Xpred,Model.PLSmodel{1}.bsco,Model.PLSmodel{1}.P,Model.PLSmodel{1}.Q,Model.PLSmodel{1}.W,no_of_lv);

predModel.Ypred0=ones(size(Xpred,1),1)*mean(Model.rawY); % For zero PLSC estimate as average of calibration segment

% Back transformation - Y
[Ytrans_cal,my,stdy]=auto(Model.rawY);
for i=1:no_of_lv
    predModel.Ypred(:,:,i)=scaleback(Ypred(:,:,i),my,stdy);
end

if nargin==4
  for i=1:no_of_lv
    [RMSE(i),Bias(i)]=rmbi(Yref,predModel.Ypred(:,:,i));
  end
  [RMSE0,Bias0]=rmbi(Yref,predModel.Ypred0);
   predModel.RMSE=[RMSE0 RMSE];
   predModel.Bias=[Bias0 Bias];
else
  predModel.RMSE=[];
  predModel.Bias=[];
end

predModel.CalModel=Model; % From input

% Subfunctions
function [RMSE,Bias]=rmbi(Yref,Ypred)
[n,m]=size(Yref);
RMSE = sqrt( sum(sum((Ypred-Yref).^2))/(n*m) );
Bias = sum(sum(Ypred-Yref))/(n*m);

function [Xmsc,Xmeancal]=msc(X)
[n,m]=size(X);
Xmeancal=mean(X);
for i=1:n
  coef=polyfit(Xmeancal,X(i,:),1);
  Xmsc(i,:)=(X(i,:)-coef(2))/coef(1);
end

function Xpmsc=msc_pre(Xp,Xmeancal)
[n,m]=size(Xp);
for i=1:n
  coef=polyfit(Xmeancal,Xp(i,:),1);
  Xpmsc(i,:)=(Xp(i,:)-coef(2))/coef(1);
end

function [Xmean,meanX] = mncn(X)
[n,m] = size(X);
meanX = mean(X);
Xmean = (X-meanX(ones(n,1),:));

function [Xauto,meanX,stdX] = auto(X)
[n,m] = size(X);
meanX = mean(X);
stdX  = std(X);
Xauto = (X-meanX(ones(n,1),:))./stdX(ones(n,1),:);

function Xscalenew = scalenew(Xnew,meanXold,stdXold)
[n,m] = size(Xnew);
if nargin == 2
  Xscalenew = (Xnew-meanXold(ones(n,1),:));
elseif nargin == 3
  Xscalenew = (Xnew-meanXold(ones(n,1),:))./stdXold(ones(n,1),:);
end

function Xscaleback = scaleback(X,meanX,stdX)
[n,m] = size(X);
if nargin == 2
  Xscaleback = X + meanX(ones(n,1),:);
elseif nargin == 3
  Xscaleback = (X.*stdX(ones(n,1),:)) + meanX(ones(n,1),:);
end
