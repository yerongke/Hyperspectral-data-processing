function Model=ipls(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments)

%  ipls calculates the interval models based on PLS
%  Input:
%   Model  结构体
%  X is the independent variables
%  Y is the dependent variable(s), NOTE: Y is allways autoscaled
%  no_of_lv is the maximum number of PCA or PLS components
%  prepro_method (for X only) is 'mean', 'auto', 'mscmean' or 'mscauto'
%     Note: msc is performed in each interval
%  intervals is the number of intervals 区间数目
%     if intervals is a row vector divisions are made based on the elements
%     [startint1 endint1 startint2 endint2 startint3 endint3], see an example in manint
%  xaxislabels (self explainable), if not available type []
%  val_method is 'test', 'full', 'syst111', 'syst123', 'random', or
%     'manual'; the last five are cross validation based methods
%  segments (segments = number of samples corresponds to full cv)
%     if intervals is a cell array cross validation is performed according
%     to this array, see the script ma
%  keManualSegments
%
%  Output:
%  Model is a structured array containing all model information
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars N鴕gaard, July 2004
%
%  Model=ipls(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);

if nargin==0
   disp(' ')
   disp(' Model=ipls(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);')
   disp(' ')
   disp(' Example:')
   disp(' Model=ipls(X,Y,7,''mean'',20,xaxis,''syst123'',5);')
   disp(' ')
   return
end

% Error checks
if ~ismember(val_method,{'test', 'full', 'syst123', 'syst111', 'random', 'manual'})
    disp(' Not allowed validation method')
    Model=[];
    return
end

if ~ismember(prepro_method,{'mean', 'auto', 'mscmean', 'mscauto', 'none'})
    disp(' Not allowed preprocessing method')
    Model=[];
    return
end

if strcmp(lower(val_method),'manual') & ~iscell(segments)
    disp('You need to specify the manual segments in a cell array, see makeManualSegments')
    Model=[];
    return
end

if strcmp(lower(val_method),'manual') & iscell(segments)
   Nsamples=0;
   for j=1:max(size(segments))
      Nsamples=Nsamples + max(size(segments{j}));
   end
   if size(X,1)~=Nsamples
      disp('The number of samples in X does not correspond to the total number of samples in segments')
      Model=[];
      return
   end
end
% End error checks

Model.type='iPLS';
Model.rawX=X;
Model.rawY=Y;
Model.no_of_lv=no_of_lv;
Model.prepro_method=prepro_method;
Model.xaxislabels=xaxislabels;
Model.val_method=val_method;

[n,m]=size(X);
if strcmp(lower(Model.val_method),'full') | nargin <8
   Model.segments=n;
else
   Model.segments=segments;
end

[nint,mint]=size(intervals);
if mint > 1
    Model.allint=[(1:round(mint/2)+1)' [intervals(1:2:mint)';1] [intervals(2:2:mint)';m]];
    Model.intervals=round(mint/2);
    Model.intervalsequi=0;
else
    Model.intervals=intervals;
    vars_left_over=mod(m,intervals);
    N=fix(m/intervals);
    % Distributes vars_left_over in the first "vars_left_over" intervals
    startint=[(1:(N+1):(vars_left_over-1)*(N+1)+1)'; ((vars_left_over-1)*(N+1)+1+1+N:N:m)'];
    endint=[startint(2:intervals)-1; m];
    Model.allint=[(1:intervals+1)' [startint;1] [endint;m]];
    Model.intervalsequi=1;
end

% Local calibration
for i=1:size(Model.allint,1)
   if i<size(Model.allint,1)
      home, s = sprintf('Working on interval no. %g of %g...',i,size(Model.allint,1)-1); disp(s)
   else
      home, disp('Working on full spectrum model...')
   end
   Model.PLSmodel{i}=pls_val(X(:,[Model.allint(i,2):Model.allint(i,3)]),Y,Model.no_of_lv,Model.prepro_method,Model.val_method,Model.segments);
end
