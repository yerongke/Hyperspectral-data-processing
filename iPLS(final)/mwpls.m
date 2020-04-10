function mwModel=mwpls(X,Y,no_of_lv,prepro_method,windowsize,xaxislabels,val_method,segments)

%  mwpls calculates the moving window PLS models
%
%  Input:
%  X is the independent variables
%  Y is the dependent variable(s), NOTE: Y is allways autoscaled
%  no_of_lv is the maximum number of PLS components
%  prepro_method (for X only) is 'mean', 'auto', 'mscmean' or 'mscauto'
%  windowsize is the size of the moving window (should be an odd number!)
%  xaxislabels (self explainable), if not available type []
%  val_method is 'syst111', 'syst123', 'random', 'full' or 'manual'
%  segments (segments = number of samples corresponds to full cv)
%
%  Output:
%  mwModel is a structured array containing all model information
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  mwModel=mwpls(X,Y,no_of_lv,prepro_method,windowsize,xaxislabels,val_method,segments);

if nargin==0
   disp(' ')
   disp(' mwModel=mwpls(X,Y,no_of_lv,prepro_method,windowsize,xaxislabels,val_method,segments);')
   disp(' ')
   disp(' Example:')
   disp(' mwModel=mwpls(X,Y,7,''mean'',21,[],''syst123'',5);')
   disp(' ')
   return
end

% Error checks
if ~ismember(val_method,{'test', 'full', 'syst123', 'syst111', 'random', 'manual'})
    disp(' Not allowed validation method')
    mwModel=[];
    return
end

if ~ismember(prepro_method,{'mean', 'auto', 'mscmean', 'mscauto', 'none'})
    disp(' Not allowed preprocessing method')
    mwModel=[];
    return
end

if strcmp(lower(val_method),'manual') & ~iscell(segments)
    disp('You need to specify the manual segments in a cell array, see makeManualSegments')
    mwModel=[];
    return
end

if strcmp(lower(val_method),'manual') & iscell(segments)
   Nsamples=0;
   for j=1:max(size(segments))
      Nsamples=Nsamples + max(size(segments{j}));
   end
   if size(X,1)~=Nsamples
      disp('The number of samples in X does not correspond to the total number of samples in segments')
      mwModel=[];
      return
   end
end
% End error checks

mwModel.type='Moving window';
mwModel.rawX=X;
mwModel.rawY=Y;
mwModel.no_of_lv=no_of_lv;
mwModel.prepro_method=prepro_method;
mwModel.xaxislabels=xaxislabels;
mwModel.val_method=val_method;

if nargin<8 & strcmp(val_method,'full')
    mwModel.segments=size(X,1);
else
    mwModel.segments=segments;
end

if nargin==8 & strcmp(val_method,'full')
   mwModel.segments=size(X,1);
end

mwModel.windowsize=windowsize;

% Local calibration
for i=1:size(X,2)
   if i<size(X,2)
      home, s = sprintf('Working on interval no. %g of %g...',i,size(X,2)); disp(s)
   else
      home, disp('Working on full spectrum calibration...')
   end
   if i<=(windowsize-1)/2
       selectedwindow=1:(i+(windowsize-1)/2);
   elseif i>size(X,2)-(windowsize-1)/2
       selectedwindow=(i-(windowsize-1)/2):size(X,2);
   else
       selectedwindow=(i-(windowsize-1)/2):(i+(windowsize-1)/2);
   end
   mwModel.PLSmodel{i}=pls_val(X(:,selectedwindow),Y,no_of_lv,prepro_method,val_method,mwModel.segments);
end

mwModel.PLSmodel{size(X,2)+1}=pls_val(X,Y,no_of_lv,prepro_method,val_method,mwModel.segments);
