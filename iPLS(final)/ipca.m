function Model=ipca(X,no_of_lv,prepro_method,intervals,xaxislabels)

%  ipca calculates the interval models based on PCA
%
%  Input:
%  X is the independent variables
%  no_of_lv is the maximum number of PCA or PLS components
%  prepro_method (for X only) is 'mean', 'auto', 'mscmean', 'mscauto' or 'none'
%     Note: msc is performed with a basis in each interval
%  intervals is the number of intervals
%     if intervals is a row vector divisions are made based on the elements
%     [startint1 endint1 startint2 endint2 startint3 endint3], see an example in manint
%  xaxislabels (self explainable), if not available type []
%
%  NOTE: No validation is performed for iPCA models
%
%  Output:
%  Model is a structured array containing all model information
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  Model=ipca(X,no_of_lv,prepro_method,intervals,xaxislabels);

if nargin==0
   disp(' ')
   disp(' Model=ipca(X,no_of_lv,prepro_method,intervals,xaxislabels);')
   disp(' ')
   disp(' Example:')
   disp(' Model=ipca(X,7,''mean'',20,xaxis);')
   disp(' ')
   return
end

% Error checks
if ~ismember(prepro_method,{'mean', 'auto', 'mscmean', 'mscauto', 'none'})
    disp(' Not allowed preprocessing method')
    Model=[];
    return
end
% End error checks

Model.type='iPCA';
Model.rawX=X;
Model.rawY=[];
Model.no_of_lv=no_of_lv;
Model.prepro_method=prepro_method;

Model.xaxislabels=xaxislabels;
Model.val_method='none';
Model.segments=[];

[n,m]=size(X);
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
   Model.PCAmodel{i}=pca(X(:,[Model.allint(i,2):Model.allint(i,3)]),no_of_lv,prepro_method);
end
