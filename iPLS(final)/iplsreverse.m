function ModelsReverse=iPLSreverse(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments)

%  iPLSreverse calculates iPLS models WITHOUT the given interval (opposite of ipls)
%
%  Input:
%  X is the independent variables
%  Y is the dependent variable(s), NOTE: Y is allways autoscaled
%  no_of_lv is the maximum number of PLS components
%  intervals is the number of intervals
%     if intervals is a row vector divisions are made based on the elements
%     [startint1 endint1 startint2 endint2 startint3 endint3], see an example in manint
%  val_method is 'test' 'full' 'syst111', 'syst123', 'random' or 'manual'
%  prepro_method (for X only) is 'mean', 'auto', 'mscmean' or 'mscauto'
%  xaxislabels (self explainable), if not available type []
%  segments (segments = number of samples corresponds to full cv)
%
%  Output:
%  ModelsReverse is a structured array containing all model information
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, September 2002
%
%  ModelsReverse=iPLSreverse(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);

if nargin==0
   disp(' ')
   disp(' ModelsReverse=iPLSreverse(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);')
   disp(' ')
   disp(' Example:')
   disp(' ModelsReverse=iPLSreverse(X,Y,7,''mean'',20,[],''syst123'',5);')
   disp(' ')
   return
end

ModelsReverse.rawX=X;
ModelsReverse.rawY=Y;
ModelsReverse.no_of_lv=no_of_lv;
ModelsReverse.xaxislabels=xaxislabels;
ModelsReverse.val_method=val_method;
ModelsReverse.segments=segments;
ModelsReverse.prepro_method=prepro_method;

[n,m]=size(X);
if strcmp(val_method,'full')
   ModelsReverse.segments=n;
end

% Error checks
if max(size(segments))>1 & strcmp(val_method,'manual')
   Nsamples=0;
   for j=1:max(size(segments))
      Nsamples=Nsamples + max(size(segments{j}));
   end
   if size(ModelsReverse.rawX,1)~=Nsamples
      disp('The number of samples in X does not correspond to the number of samples in segments')
      return
   end
end

[nint,mint]=size(intervals);
if mint > 1
    ModelsReverse.allint=[(1:round(mint/2)+1)' [intervals(1:2:mint)';1] [intervals(2:2:mint)';m]];
    ModelsReverse.intervals=round(mint/2);
    ModelsReverse.intervalsequi=0;
else
    ModelsReverse.intervals=intervals;
    vars_left_over=mod(m,intervals);
    N=fix(m/intervals);
    % Distributes vars_left_over in the first "vars_left_over" intervals
    startint=[(1:(N+1):(vars_left_over-1)*(N+1)+1)'; ((vars_left_over-1)*(N+1)+1+1+N:N:m)'];
    endint=[startint(2:intervals)-1; m];
    ModelsReverse.allint=[(1:intervals+1)' [startint;1] [endint;m]];
    ModelsReverse.intervalsequi=1;
end

% Local calibration
GlobalIntervalInformation=[ModelsReverse.allint(ModelsReverse.intervals+1,2):ModelsReverse.allint(ModelsReverse.intervals+1,3)];
for i=1:size(ModelsReverse.allint,1)
   if i<size(ModelsReverse.allint,1)
      home, s = sprintf('Working on interval no. %g of %g...',i,size(ModelsReverse.allint,1)-1); disp(s)
   else
      home, disp('Working on full spectrum calibration...')
   end
   GlobalWithoutIntervalWithout=GlobalIntervalInformation;
   GlobalWithoutIntervalWithout([ModelsReverse.allint(i,2):ModelsReverse.allint(i,3)])=[];
   if i==ModelsReverse.intervals+1
       ModelsReverse.PLSmodel{i}=pls_val(X(:,[ModelsReverse.allint(i,2):ModelsReverse.allint(i,3)]),Y,no_of_lv,prepro_method,val_method,segments);
   else
       ModelsReverse.PLSmodel{i}=pls_val(X(:,GlobalWithoutIntervalWithout),Y,no_of_lv,prepro_method,val_method,segments);
   end
end
