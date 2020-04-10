function biplstable(biModel)

%  biplstable
%  Input: biModel which is the output from bipls.m
%
%  biplstable(biModel);

if nargin==0
   disp(' ')
   disp(' biPLStable(biModel);')
   disp(' ')
   return
end

StartSizeRevIntInfo=size(biModel.RevIntInfo,1);

if size(biModel.RevIntInfo,1)~=size(biModel.RevRMSE,1)
    start_interval_to_remove=size(biModel.RevRMSE,1);
    biModel.RevIntInfo(start_interval_to_remove:end,:)=[];
    biModel.RevRMSE(start_interval_to_remove:end,:)=[];    
    biModel.RevVars(start_interval_to_remove:end,:)=[];
end

disp(' ')
disp('    Number    Interval    RMSE      Number of Variables')
disp('    ---------------------------------------------------')

for i=1:size(biModel.RevIntInfo,1)
    tabletext=sprintf('      %2g         %2g       %0.4f           %3g',[StartSizeRevIntInfo-(i-1) biModel.RevIntInfo(i) biModel.RevRMSE(i) biModel.RevVars(i)]);
    disp(tabletext)
end
disp(' ')
