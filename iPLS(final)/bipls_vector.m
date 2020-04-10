function ix_vector=bipls_vector(biplslimitModel,OrigVars,OrigIntervals)

%  bipls_vector
%  Input:
%    biplslimitModel
%    OrigVars: number of original variables (e.g. 926)
%    OrigIntervals: number of original intervals (e.g. 20)
%  Output:
%    ix_vector: index of the variables selected
%
%  ix_vector=bipls_vector(biplslimitModel,OrigVars,OrigIntervals);

if nargin==0
   disp(' ')
   disp(' ix_vector=bipls_vector(biplslimitModel,OrigVars,OrigIntervals);')
   disp(' ')
   disp(' ix_vector=bipls_vector(biplslimitModel,926,20));')
   disp(' ')
   return
end

ix=find(biplslimitModel.RevVars<400);
ix=biplslimitModel.RevIntInfo(ix);

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

ix_vector=[];
for i=1:size(ix,1)
    ix_vector=[ix_vector allint(ix(i),2):allint(ix(i),3)];
end
ix_vector=sort(ix_vector);