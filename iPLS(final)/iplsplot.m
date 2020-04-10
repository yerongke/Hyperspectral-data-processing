function iplsplot(Model,labeltype,optimal_lv_global,max_yaxis,plottype)

%  iplsplot plots results from iPLS analysis in a bar plot
%
%  Input:
%  Model (the output from ipls.m)
%  labeltype designates whether you want:
%    interval number ('intlabel'),
%  	 variable number ('varlabel')
%    wavelength number ('wavlabel')
%  optimal_lv_global: optional, the number of PLS components chosen for full spectrum model
%     if not given or given by [] the first RMSECV/RMSEP minimum is chosen
%  max_yaxis is optional (can be used to control scaling of the iPLS plot)
%  plottype is optional:
%    'Cum' (default)
%    'Cum2' (with the RMSE values of the two preceeding PLS components)
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  iplsplot(Model,labeltype,optimal_lv_global,max_yaxis,plottype);

if nargin==0
   disp(' ')
   disp(' iplsplot(Model,labeltype,optimal_lv_global,max_yaxis,plottype);')
   disp(' or')
   disp(' iplsplot(Model,labeltype);')
   disp(' ')
   disp(' Examples:')
   disp(' iplsplot(Model,''intlabel'',[],[],''Cum2'');')
   disp(' ')
   disp(' iplsplot(Model,''intlabel'');')
   disp(' ')
   return
end

% Error checks
if ~isstruct(Model)
    disp('Model input should be a structure array (output from ipls.m)')
    return
end

if ~strcmp(Model.type,'iPLS')
    disp('The model input is not from an iPLS model')
    return
end

if nargin==5 & ~ismember(plottype,{'Cum','Cum2'})
    disp('Not legal plottype, use ''Cum'' or ''Cum2''')
    return
end

if ~ismember(labeltype,{'intlabel','varlabel','wavlabel'})
    disp('Not legal labeltype, use ''intlabel'',''varlabel'', or ''wavlabel''')
    return
end

if Model.intervalsequi==0 & strcmp(labeltype,'intlabel')
   disp(' ')
   disp(' Manually chosen intervals are not correctly plotted with ''intlabel''')
   disp(' so please use ''varlabel'' or ''wavlabel'' as labeltype')
   disp(' ')
end
% End error checks

Xmean = mean(Model.rawX); % Mean spectrum
if min(Xmean)<0
   Xmean=Xmean+(-min(Xmean)); % To make all intensities positive
end
[n,m] = size(Model.rawX);

No_Int = Model.intervals;
if strcmp(labeltype,'intlabel')
   Xtext = sprintf('Interval number');
   Xint =[Model.allint(1:No_Int,1)-0.5 Model.allint(1:No_Int,1)-0.5 Model.allint(1:No_Int,1)+0.5 Model.allint(1:No_Int,1)+0.5]';
   NumberofTicksandWhere=mean(Xint(2:3,:));
elseif strcmp(labeltype,'wavlabel')
   if isempty(Model.xaxislabels)
      disp('You must define wavelength/wavenumber labels')
      return
   end
   Xtext = sprintf('Wavelength/Wavenumber');
   a = Model.allint(1:No_Int,2);
   b = Model.allint(1:No_Int,3);

   % To reverse wavenumber axis before plotting; will be reversed back when the
   % final plot is made
   NewAxisLabels=Model.xaxislabels; % Important; original axislabels are used in the last three lines of the program
   if NewAxisLabels(1)>NewAxisLabels(2)
       if size(NewAxisLabels,1)==1
           NewAxisLabels=fliplr(NewAxisLabels);
       elseif size(NewAxisLabels,2)==1
           NewAxisLabels=flipud(NewAxisLabels);
       end
   end
   
   Xint = [NewAxisLabels(a)' NewAxisLabels(a)' NewAxisLabels(b)' NewAxisLabels(b)']';
   NumberofTicksandWhere=[Xint(2,:) Xint(3,end)];

elseif strcmp(labeltype,'varlabel')
   Xtext = sprintf('Variable number');
   Xint  = [Model.allint(1:No_Int,2) Model.allint(1:No_Int,2) Model.allint(1:No_Int,3) Model.allint(1:No_Int,3)]';
   NumberofTicksandWhere=[Xint(2,:) Xint(3,end)];
end

for i=1:(Model.intervals+1)
   RMSE(i,:) = Model.PLSmodel{i}.RMSE;
end

% [minRMSE,min_ix]=min(RMSE'); % Global minima; could be changed using e.g. F-test or equal

% First local minima is better; could be changed using e.g. F-test or equal NOT IMPLEMENTED
% Ones appended to make the search stop if the first local miminum is the last PLSC
RedRMSE=RMSE(:,2:end); % PLSC0 is excluded in finding the first local minimum
SignMat=[sign(diff(RedRMSE')') ones(No_Int+1,1)];

for i=1:size(RedRMSE,1)
    for j=1:size(RedRMSE,2)
        if SignMat(i,j)==1
            min_ix(i)=j; % Note: PLSC0 is excluded
            minRMSE(i)=RedRMSE(i,j); % Note: PLSC0 is excluded
            break
        end
    end
end

if nargin==2
  optimal_lv_global=min_ix(Model.intervals+1);
end

if nargin >2 & isempty(optimal_lv_global)
  optimal_lv_global=min_ix(Model.intervals+1);
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
Response = [zeros(No_Int,1) minRMSE(1:No_Int)' minRMSE(1:No_Int)' zeros(No_Int,1)]';

for i=1:No_Int
    if min_ix(i)==1
        minRMSEminusOne(i)=NaN;
    else
        minRMSEminusOne(i)=RMSE(i,min_ix(i));
    end
end
ResponseMinusOnePC = [zeros(No_Int,1) minRMSEminusOne' minRMSEminusOne' zeros(No_Int,1)]';

for i=1:No_Int
    if min_ix(i)<=2
        minRMSEminusTwo(i)=NaN;
    else
        minRMSEminusTwo(i)=RMSE(i,min_ix(i)-1);
    end
end
ResponseMinusTwoPC = [zeros(No_Int,1) minRMSEminusTwo' minRMSEminusTwo' zeros(No_Int,1)]';

% Cumulated plots
if nargin==5 & strcmp(plottype,'Cum2')
    % fill(Xint(:),Response(:),'c',Xint(:),ResponseMinusOnePC(:),'c',Xint(:),ResponseMinusTwoPC(:),'c') % DOESN'T WORK!!
    if strcmp(labeltype,'wavlabel') & (Model.xaxislabels(1)>Model.xaxislabels(2))
        fill(flipud(Xint(:)),ResponseMinusTwoPC(:),'w',flipud(Xint(:)),ResponseMinusOnePC(:),'w', flipud(Xint(:)),Response(:),[0.75 0.75 0.75])
    else
        fill(Xint(:),ResponseMinusTwoPC(:),'w',Xint(:),ResponseMinusOnePC(:),'w', Xint(:),Response(:),[0.75 0.75 0.75])
    end
elseif nargin <5 | strcmp(plottype,'Cum')
    if strcmp(labeltype,'wavlabel') & (Model.xaxislabels(1)>Model.xaxislabels(2))
        fill(flipud(Xint(:)),Response(:),'c')
    else
        fill(Xint(:),Response(:),[0.75 0.75 0.75]) % Note: substitute [0.75 0.75 0.75]'c' for cyan
    end
else
    % Nothing
end

if strcmp(Model.val_method,'test')
    plottitle = sprintf('Dotted line is RMSEP (%g LV''s) for global model / Italic numbers are optimal LVs in interval model',optimal_lv_global);
    ylabel('RMSEP','FontSize',10)
elseif strcmp(Model.val_method,'none')
    plottitle = sprintf('Dotted line is RMSEC (%g LV''s) for global model / Italic numbers are optimal LVs in interval model',optimal_lv_global);
    ylabel('RMSEC','FontSize',10)
else
    plottitle = sprintf('Dotted line is RMSECV (%g LV''s) for global model / Italic numbers are optimal LVs in interval model',optimal_lv_global);
    ylabel('RMSECV','FontSize',10)
end
title(plottitle,'FontSize',10,'FontWeight','Bold')
xlabel(Xtext)

hold on
    axis tight;
    horzline(RMSE(No_Int+1,optimal_lv_global+1),':r')
    actualaxis=axis;
    if nargin >= 4 & ~isempty(max_yaxis)
        axis([actualaxis(1) actualaxis(2) actualaxis(3) max_yaxis]);
        actualaxis(4)=max_yaxis;
    end
    Xaxis = linspace(actualaxis(1),actualaxis(2),m);
    if strcmp(labeltype,'wavlabel') & (Model.xaxislabels(1)>Model.xaxislabels(2))
        plot(fliplr(Xaxis),Xmean./max(Xmean)*actualaxis(4),'-k') % Scaled spectrum
    else
        plot(Xaxis,Xmean./max(Xmean)*actualaxis(4),'-k') % Scaled spectrum
    end
    set(gca,'XTick',NumberofTicksandWhere)
    for i=1:Model.intervals
      	if strcmp(labeltype,'wavlabel') & (Model.xaxislabels(1)>Model.xaxislabels(2))
            text(mean(Xint(2:3,i)),0.03*(actualaxis(4)-actualaxis(3))+actualaxis(3),int2str(min_ix(Model.intervals-(i-1))),'Color','r','FontAngle','italic');
        else
            text(mean(Xint(2:3,i)),0.03*(actualaxis(4)-actualaxis(3))+actualaxis(3),int2str(min_ix(i)),'Color','r','FontAngle','italic');
        end
    end
hold off

% To reverse in case of reversed wavenumber axis
if strcmp(labeltype,'wavlabel') & (Model.xaxislabels(1)>Model.xaxislabels(2))
    set(gca,'XDir','reverse');
end
% end
