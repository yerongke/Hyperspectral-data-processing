function mwplsplot(mwModel,labeltype,optimal_lv_global,max_yaxis)

%  mwplsplot plots model parameters from moving window PLS analysis
%  Note: wavelenght label not implemented
%
%  Input:
%  mwModel (the output from mwPLS.m)
%  labeltype (optional):
%     variable number: 'varlabel' (default)
%  optimal_lv_global (optional): number of PLS components chosen for full spectrum model
%  max_yaxis (optional): scaling of ordinate of the mwplsplot
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  mwplsplot(mwModel,optimal_lv_global,labeltype,max_yaxis);

if nargin==0
   disp(' ')
   disp(' mwplsplot(mwModel,labeltype,optimal_lv_global,max_yaxis);')
   disp(' or')
   disp(' mwplsplot(mwModel);')
   disp(' ')
   disp(' Example:')
   disp(' mwplsplot(mwModel);')
   disp(' ')
   return
end

if nargin==1
    labeltype='varlabel';
end

if nargin>1 & isempty(labeltype)
    labeltype='varlabel';
end

Xmean = mean(mwModel.rawX); % Mean spectrum
if min(Xmean)<0
   Xmean=Xmean+(-min(Xmean)); % To make all intensities positive
end
[n,m] = size(mwModel.rawX);

if strcmp(labeltype,'wavlabel')
   if isempty(mwModel.xaxislabels)
      disp('You must define wavelength labels')
      return
   end
   Xtext = sprintf('Wavelength (does not work on this plot), varlabel is plotted');
elseif strcmp(labeltype,'varlabel')
   Xtext = sprintf('Variable number');
elseif strcmp(labeltype,'intlabel')
   Xtext = sprintf('Interval number');
end

for i=1:(m+1)
   RMSE(i,:)=mwModel.PLSmodel{i}.RMSE;
end

% First local minimum
RedRMSE=RMSE(:,2:end); % To exclude PLSC0
SignMat=[sign(diff(RedRMSE')') ones(m+1,1)];

for i=1:size(RedRMSE,1)
    for j=1:size(RedRMSE,2)
        if SignMat(i,j)==1
            min_ix(i)=j; % Note: PLSC0 is excluded
            minRMSE(i)=RedRMSE(i,j);
            break
        end
    end
end

if nargin<=2
  optimal_lv_global=min_ix(m+1);
end

if nargin >2 & isempty(optimal_lv_global)
  optimal_lv_global=min_ix(m+1);
end

set(0,'Units','pixels');
Scrsiz=get(0,'ScreenSize');
ScrLength=Scrsiz(3);
ScrHight=Scrsiz(4);
bdwidth=10;
% [left(->) bottom(up) width hight]
figpos=[0.1*ScrLength 0.15*ScrHight 0.85*ScrLength 0.75*ScrHight];
figure(1)
set(1,'Position',figpos)

if mwModel.windowsize==1 | size(mwModel.PLSmodel{1}.RMSE,2)==1
    plot(RMSE(1:m),'k')
else
    plot(minRMSE(1:m),'k')
end

switch mwModel.val_method
  case 'test'
    plottitle = sprintf('Dotted line is RMSEP (%g LV''s) for global model / Windowsize is %g for local models',optimal_lv_global,mwModel.windowsize);
    ylabel('RMSEP','FontSize',10)
  otherwise
    plottitle = sprintf('Dotted line is RMSECV (%g LV''s) for global model / Windowsize is %g for local models',optimal_lv_global,mwModel.windowsize);
    ylabel('RMSECV','FontSize',10)
end
title(plottitle,'FontSize',10,'FontWeight','Bold')
xlabel(Xtext)

hold on
    axis tight;
    horzline(RMSE(m+1,optimal_lv_global+1),':k')
    actualaxis=axis;
    if nargin == 4
        axis([actualaxis(1) actualaxis(2) 0 max_yaxis]);
        actualaxis(4)=max_yaxis;
    else
        axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)]);
    end
    plot(Xmean./max(Xmean)*actualaxis(4),'-b') % Scaled spectrum
hold off
