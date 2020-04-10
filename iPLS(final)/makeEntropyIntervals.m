function EntropyInt=makeEntropyIntervals(X,intervals)

%  makeEntropyIntervals gives indices for entropy intervals based on std (Ralf Torgrip)
%
%  Input:
%  X is the independent variables
%  intervals: the number of intervals wanted, e.g. 20
%
%  Output:
%  EntropyInt is a double array containing interval information for direct use with ipls
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, March 2004
%
%  EntropyInt=makeEntropyIntervals(X,intervals);

if nargin==0
   disp(' ')
   disp(' EntropyInt=makeEntropyIntervals(X,intervals);')
   disp(' ')
   return
end

deviations=std(X);
splitpoint=sum(deviations)/(intervals);

sumdev=cumsum(deviations);

EntropyInt=[];
for i=1:intervals
   ix=find((i-1)*splitpoint<=sumdev & sumdev<=i*splitpoint);
   EntropyInt=[EntropyInt ix(1) ix(end)];
end
