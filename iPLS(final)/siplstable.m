function siplstable(siModel)

%  siPLStable lists optimal interval combinations, corresponding RMSEs and PLSC
%
%  Input:
%  siModel is the output from sipls.m
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  siplstable(siModel);

if nargin==0
   disp(' ')
   disp(' siplstable(siModel);')
   disp(' ')
   return
end

disp(' ')
disp(sprintf('    Original number of intervals is %2g',siModel.intervals))
disp(' ')

if max(size(siModel.IntComb{1}))==2
   disp('    PLS comp.  Intervals    RMSE')
   disp('    ------------------------------')
elseif max(size(siModel.IntComb{1}))==3
   disp('    PLS comp.     Intervals      RMSE')
   disp('    -----------------------------------')
elseif max(size(siModel.IntComb{1}))==4
	disp('    PLS comp.       Intervals         RMSE')
   disp('    ----------------------------------------')
end

for i=1:max(size(siModel.minRMSE(1:10)))
   if max(size(siModel.IntComb{1}))==2
      tabletext=sprintf('      %2g       [%2g   %2g]    %0.4g',[siModel.minPLSC(i) siModel.minComb{i} siModel.minRMSE(i)]);
	   disp(tabletext)
	elseif max(size(siModel.IntComb{1}))==3
   	tabletext=sprintf('      %2g       [%2g   %2g   %2g]    %0.4g',[siModel.minPLSC(i) siModel.minComb{i} siModel.minRMSE(i)]);
	   disp(tabletext)
	elseif max(size(siModel.IntComb{1}))==4
   	tabletext=sprintf('      %2g       [%2g   %2g   %2g   %2g]    %0.4g',[siModel.minPLSC(i) siModel.minComb{i} siModel.minRMSE(i)]);
      disp(tabletext)
   end
end

disp(' ')
