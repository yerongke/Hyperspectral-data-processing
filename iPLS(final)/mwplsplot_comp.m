function mwplsplot_comp(mwModel,labeltype,optimal_lv_global,max_yaxis)

%  mwplsplot_comp plots optimal number of components in each interval
%
%  Input:
%  mwModel (the output from mwpls.m)
%  labeltype:
%       variable number: 'varlabel' (default)
%  optimal_lv_global (optional): number of PLS components chosen for full spectrum model
%  max_yaxis (optional) for ordinate scaling of plot
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  mwplsplot_comp(mwModel,labeltype,optimal_lv_global,max_yaxis);

if nargin==0
   disp(' ')
   disp(' mwplsplot_comp(mwModel,labeltype,optimal_lv_global,max_yaxis);')
   disp(' ')
   disp(' Example:')
   disp(' mwplsplot_comp(mwModel);')
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
   if isempty(mwModel.axislabels)
      disp('You must define wavelength labels')
      return
   end
   Xtext = sprintf('Wavelength');
elseif strcmp(labeltype,'varlabel')
   Xtext = sprintf('Variable number');
elseif strcmp(labeltype,'intlabel')
   Xtext = sprintf('Variable number');
end

for i=1:(m+1)
   RMSE(i,:)=mwModel.PLSmodel{i}.RMSE;
end

% [minRMSE,min_ix]=min(RMSE'); % Could be changed using e.g. F-test or equal
% New: first local minima
RedRMSE=RMSE(:,2:end);
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

plot(min_ix(1:m),'k')

plottitle = sprintf('Dotted line is optimal components (%g) for global model / Windowsize is %g for local models',optimal_lv_global,mwModel.windowsize);
title(plottitle,'FontSize',10,'FontWeight','Bold')
xlabel(Xtext)
ylabel('No of PLS components','FontSize',10)
hold on
    axis tight;
    horzline(optimal_lv_global,':k')
    actualaxis=axis;
    if nargin == 4
        axis([actualaxis(1) actualaxis(2) 0 max_yaxis]);
        actualaxis(4)=max_yaxis;
    else
        axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)]);
    end
    plot(Xmean./max(Xmean)*actualaxis(4),'-b') % Scaled spectrum
hold off
