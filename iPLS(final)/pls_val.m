function PLSmodel = pls_val(X,Y,no_of_lv,prepro_method,val_method,segments);

%  pls_val for PLS modelling with selected validation method
%
%  Input:
%  X contains the independent variables
%  Y contains the dependent variable(s), NOTE: Y is allways autoscaled
%  no_of_lv is the number of PLS components
%  prepro_method is 'mean', 'auto', 'mscmean', 'mscauto' or 'none'
%  val_method is 'test', 'full', 'syst111', 'syst123', 'random' or 'manual'
%  segments is number of segments in cross validation
%       if val_method is 'test' then segments should be a column vector with test set indices
%       if val_method is 'manual' then segments should be a cell array, see makeManualSegments
%  Output:
%  PLSmodel is a structured array containing all model and validation information
%
%  Subfunctions at the end of this file: rmbi, msc, msc_pre, mncn, auto
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  PLSmodel = pls_val(X,Y,no_of_lv,prepro_method,val_method,segments);

[n,m] = size(X);
[o,p] = size(Y);

if nargin==6 & max(size(segments))==1 % Not test or manual
  no_sampl=fix(n/segments);
  left_over_samples=mod(n,segments);
end

if nargin==6 & iscell(segments)
  manualseg=segments; % A cell array
  segments=max(size(segments)); % Now a scalar
  Nsamples=0;
  for j=1:segments
    Nsamples=Nsamples + max(size(manualseg{j}));
  end
  if n~=Nsamples
    disp('The number of samples in X does not correspond to the number of samples in manualseg')
    return
  end
end

% if strcmp(lower(val_method),'full')
%     if nargin==6 & ~isempty(segments)
%         disp('No need to include segments when full cross validation is chosen')
%     end
% end

Ypred=zeros(n,p,no_of_lv);
count=1;

PLSmodel.prepro_method=prepro_method;
PLSmodel.val_method=val_method;

if strcmp(val_method,'full')
   val_method='syst123';
   segments=n;
end

if strcmp(val_method,'random')
    ix=rand(n,1);
    [temp,ix]=sort(ix);
end

switch val_method
    case 'test'
      tot=(1:n)';
      tot(segments)=[];
      cal = tot;
      Xseg=X(cal,:);
      Yseg=Y(cal,:);
      Xpseg=X(segments,:);
      [Yseg,my,stdy]=auto(Yseg);
      if strcmp(lower(prepro_method),'mean')
           [Xseg,mx]=mncn(Xseg);
           Xpseg=scalenew(Xpseg,mx);
      elseif strcmp(lower(prepro_method),'auto')
           [Xseg,mx,stdx]=auto(Xseg);
           Xpseg=scalenew(Xpseg,mx,stdx);
      elseif strcmp(lower(prepro_method),'mscmean')
           [Xseg,Xsegmeancal]=msc(Xseg);
           [Xseg,mx]=mncn(Xseg);
           Xpseg=msc_pre(Xpseg,Xsegmeancal);
           Xpseg=scalenew(Xpseg,mx);
      elseif strcmp(lower(prepro_method),'mscauto')
           [Xseg,Xsegmeancal]=msc(Xseg);
           [Xseg,mx,stdx]=auto(Xseg);
           Xpseg=msc_pre(Xpseg,Xsegmeancal);
           Xpseg=scalenew(Xpseg,mx,stdx);
      elseif strcmp(lower(prepro_method),'none')
           % To secure that no centering/scaling is OK    
      end
      [P,Q,W,T,U,bsco,ssqdif]=pls(Xseg,Yseg,no_of_lv);
      Ypred(segments,:,:)=pls_pre(Xpseg,bsco,P,Q,W,no_of_lv);
      for j=1:no_of_lv
        Ypred(segments,:,j)=scaleback(Ypred(segments,:,j),my,stdy);
      end
      Ypred0(segments,:)=ones(max(size(segments)),1)*zeros(size(my)); % For zero PLSC estimate as average of calibration segment
      Ypred0(segments,:)=scaleback(Ypred0(segments,:),my,stdy);
      
      PLSmodel.test=segments;
      
    case {'full','syst111','syst123','random','manual'}
    % SegmentBar = waitbar(0,'Working on cross-validation...','Name','Cross-validation...'); % NEW
	for i=1:segments
        % waitbar(i/segments,SegmentBar,['Performing cross-validation on segment',num2str(i),' of ',num2str(segments)]); % NEW
        if strcmp(val_method,'syst111')
              if left_over_samples==0
                   count=count;
                   p_cvs=((i-1)*no_sampl+1+(count-1):i*no_sampl+(count-1))';
              else   
                   p_cvs=((i-1)*no_sampl+1+(count-1):i*no_sampl+count)';
                   count=count+1;
                   left_over_samples=left_over_samples-1;
              end
         elseif strcmp(val_method,'syst123')
              p_cvs=(i:segments:n)';
         elseif strcmp(val_method,'random')
              p_cvs=(i:segments:n)';
              p_cvs=ix(p_cvs)';
         elseif strcmp(val_method,'manual')
              p_cvs=manualseg{i};
         end
         tot=(1:n)';
         tot(p_cvs)=[];
         m_cvs = tot;
         PLSmodel.cv{i}=p_cvs;
         Xseg=X(m_cvs,:);
         Yseg=Y(m_cvs,:);
         Xpseg=X(p_cvs,:);
         [Yseg,my,stdy]=auto(Yseg);
         if strcmp(lower(prepro_method),'mean')
              [Xseg,mx]=mncn(Xseg);
              Xpseg=scalenew(Xpseg,mx);
         elseif strcmp(lower(prepro_method),'auto')
              [Xseg,mx,stdx]=auto(Xseg);
              Xpseg=scalenew(Xpseg,mx,stdx);
         elseif strcmp(lower(prepro_method),'mscmean')
              [Xseg,Xsegmeancal]=msc(Xseg);
              [Xseg,mx]=mncn(Xseg);
              Xpseg=msc_pre(Xpseg,Xsegmeancal);
              Xpseg=scalenew(Xpseg,mx);
         elseif strcmp(lower(prepro_method),'mscauto')
              [Xseg,Xsegmeancal]=msc(Xseg);
              [Xseg,mx,stdx]=auto(Xseg);
              Xpseg=msc_pre(Xpseg,Xsegmeancal);
              Xpseg=scalenew(Xpseg,mx,stdx);
         elseif strcmp(lower(prepro_method),'none')
              % To secure that no centering/scaling is OK    
         end
         [P,Q,W,T,U,bsco,ssqdif]=pls(Xseg,Yseg,no_of_lv);
         Ypred(p_cvs,:,:)=pls_pre(Xpseg,bsco,P,Q,W,no_of_lv);
         for j=1:no_of_lv
           Ypred(p_cvs,:,j)=scaleback(Ypred(p_cvs,:,j),my,stdy);
         end
         Ypred0(p_cvs,:)=ones(max(size(p_cvs)),1)*zeros(size(my)); % For zero PLSC estimate as average of calibration segment
         Ypred0(p_cvs,:)=scaleback(Ypred0(p_cvs,:),my,stdy);
	end
	% delete(SegmentBar); % NEW
end % switch val_method

switch val_method
  case 'test'
    [RMSE0,Bias0]=rmbi(Y(segments,:),Ypred0(segments,:));
  otherwise
    [RMSE0,Bias0]=rmbi(Y,Ypred0);
end

for i=1:no_of_lv
  switch val_method
    case 'test'
      [RMSE(i),Bias(i)]=rmbi(Y(segments,:),Ypred(segments,:,i)); % Subfunction at the end of this file
    otherwise
      [RMSE(i),Bias(i)]=rmbi(Y,Ypred(:,:,i)); % Subfunction at the end of this file
  end
end

PLSmodel.Ypred0=Ypred0;
PLSmodel.Ypred=Ypred;
PLSmodel.RMSE=[RMSE0 RMSE];
PLSmodel.Bias=[Bias0 Bias];

% Global model with all samples
[Y,my,stdy]=auto(Y);
if strcmp(lower(prepro_method),'mean')
	[X,mx]=mncn(X);
elseif strcmp(lower(prepro_method),'auto')
	[X,mx,stdx]=auto(X);
elseif strcmp(lower(prepro_method),'mscmean')
	X=msc(X);
	[X,mx]=mncn(X);
elseif strcmp(lower(prepro_method),'mscauto')
	X=msc(X);
	[X,mx,stdx]=auto(X);
elseif strcmp(lower(prepro_method),'none')
    disp('No scaling')
    % To secure that no centering/scaling is OK    
end

[PLSmodel.P,PLSmodel.Q,PLSmodel.W,PLSmodel.T,PLSmodel.U,PLSmodel.bsco,PLSmodel.ssqdif]=pls(X,Y,no_of_lv);

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
