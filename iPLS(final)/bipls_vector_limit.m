function ix_vector=bipls_vector_limit(biplslimitModel,OrigVars,OrigIntervals)

%  bipls_vector_limit
%  Input:
%    biplslimitModel (outout from bipls_limit.m)
%    OrigVars: number of original variables (e.g. 926)
%    OrigIntervals: number of original intervals (e.g. 20)
%  Output:
%    ix_vector: index of the variables selected
%
%  ix_vector=bipls_Vector_Limit(biplslimitModel,OrigVars,OrigIntervals));

if nargin==0
   disp(' ')
   disp(' ix_vector=bipls_vector_limit(biplslimitModel,OrigVars,OrigIntervals));')
   disp(' ')
   disp(' ix_vector=bipls_vector_limit(biplslimitModel,926,20));')
   disp(' ')
   return
end

for i=1:size(biplslimitModel.RevIntInfo,1)
  if biplslimitModel.RevIntInfo(i)==0;
    int_ix=i-1;
    break
  end
end

[nint,mint]=size(OrigIntervals);
if mint > 1
    allint=[(1:round(mint/2)+1)' [OrigIntervals(1:2:mint)';1] [OrigIntervals(2:2:mint)';OrigVars]];
    OrigIntervals=round(mint/2);
else
    vars_left_over=mod(OrigVars,OrigIntervals);
    N=fix(OrigVars/OrigIntervals);
    % Distributes vars_left_over in the first "vars_left_over" intervals
    startint=[(1:(N+1):(vars_left_over-1)*(N+1)+1)'; ((vars_left_over-1)*(N+1)+1+1+N:N:OrigVars)'];
    endint=[startint(2:OrigIntervals)-1; OrigVars];
    allint=[(1:OrigIntervals+1)' [startint;1] [endint;OrigVars]];
end

out_vector=[];
for i=1:int_ix
    out_vector=[out_vector allint(biplslimitModel.RevIntInfo(i),2):allint(biplslimitModel.RevIntInfo(i),3)];
end
ix_vector=(1:OrigVars);
ix_vector(out_vector)=[];
ix_vector=sort(ix_vector);
