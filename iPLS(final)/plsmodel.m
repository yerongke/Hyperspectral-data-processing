function oneModel=plsmodel(Model,selected_intervals,no_of_lv,prepro_method,val_method,segments)

%  plsmodel calculates a combined PLS model from selected interval(s)
%
%  Input:
%  Model: output from ipls, bipls, mwpls or sipls
%  selected_intervals are the interval numbers arranged in a vector
%  no_of_lv is the maximum number of PLS components
%  prepro_method: 'mean', 'auto', 'mscmean' or 'mscauto'
%  val_method is 'test', 'full', 'syst111', 'syst123', 'random', or 'manual'
%  segments (segments = number of samples corresponds to full cv)
%
%  Output:
%  oneModel is a structured array containing all model information
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  oneModel=plsmodel(Model,selected_intervals,no_of_lv,prepro_method,val_method,segments);

if nargin==0
   disp(' ')
   disp(' oneModel=plsmodel(Model,selected_intervals,no_of_lv,prepro_method,val_method,segments);')
   disp(' ')
   disp(' Example:')
   disp(' oneModel=plsmodel(Model,[9 11 14 18],10,''mean'',''syst123'',5);')
   disp(' ')
   return
end

oneModel.type='PLS';

oneModel.rawX=Model.rawX; % From Model
oneModel.rawY=Model.rawY; % From Model
oneModel.no_of_lv=no_of_lv; % From input
oneModel.prepro_method=prepro_method; % From input
oneModel.xaxislabels=Model.xaxislabels; % From Model
oneModel.val_method=val_method; % From input

if strcmp(lower(val_method),'full') & nargin<6
   oneModel.segments=size(Model.rawX,1);
elseif strcmp(lower(val_method),'full') & nargin==6
   oneModel.segments=size(Model.rawX,1);
else
   oneModel.segments=segments;
end

switch Model.type
  case {'iPLS','biPLS','siPLS'}
    oneModel.intervals=1; % As default
    oneModel.selected_intervals=selected_intervals; % From input
    oneModel.allint=Model.allint; % From Model
  case 'Moving window'
    oneModel.intervals=1; % As default      
    oneModel.selected_intervals=selected_intervals; % From input
    oneModel.selected_vars=[];
    oneModel.windowsize=Model.windowsize;
end

% Error checks
if strcmp(lower(val_method),'manual') & max(size(oneModel.segments))==1
   disp('You need to specify manual segments')
   return
end

% Only for manual cross validation
if max(size(oneModel.segments))>1 & strcmp(lower(val_method),'manual')
   Nsamples=0;
   for j=1:max(size(oneModel.segments))
      Nsamples=Nsamples + max(size(oneModel.segments{j}));
   end
   if size(Model.rawX,1)~=Nsamples
      disp('The number of samples in X does not correspond to the number of samples in manualseg')
      return
   end
end

if strcmp(Model.type,'Moving window')
    if selected_intervals<1 | selected_intervals>size(Model.rawX,2)
        disp('Not allowed interval number')
        return
    end
end

if strcmp(Model.type,'Moving window')
    if max(size(selected_intervals))>1
        disp('Only one interval can be selected for moving window models')
        return
    end
end
% End error checks

switch Model.type
  case {'iPLS','biPLS','siPLS'}
    selected_vars=[];
    for i=1:max(size(selected_intervals))
       temp=Model.allint(selected_intervals(i),2):Model.allint(selected_intervals(i),3);
       selected_vars=[selected_vars temp];
    end
  case 'Moving window'
       selected_vars=[selected_intervals-floor(Model.windowsize/2):selected_intervals+floor(Model.windowsize/2)];
       if selected_vars(1)<1
           selected_vars=[1:selected_intervals+floor(Model.windowsize/2)];
       elseif selected_vars(end)>size(Model.rawX,2)
           selected_vars=[selected_intervals-floor(Model.windowsize/2):size(Model.rawX,2)];
       else
           selected_vars=[selected_intervals-floor(Model.windowsize/2):selected_intervals+floor(Model.windowsize/2)];
       end
       oneModel.selected_vars=selected_vars;
end

oneModel.PLSmodel{1} = pls_val(Model.rawX(:,selected_vars),Model.rawY,no_of_lv,prepro_method,val_method,oneModel.segments);
