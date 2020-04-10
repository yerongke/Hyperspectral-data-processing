function  [Xcal_Selected, Xtest_Selected, Boshu_Selected, MinInterval, Pcs, MinRmse] = IplsSelect(Xcal, Ycal, Xtest, boshu,Intervals, MaxPcs)
%本函数的功能是采用iPLS选择波数点
Model = ipls(Xcal,Ycal,MaxPcs,'mean',Intervals, boshu,'syst123',5);
Rmse = zeros(1,Intervals);

for i = 1: Intervals
    [m, n] = min(Model.PLSmodel{1,i}.RMSE);
    Rmse(i) = m;
end

[m1,n1] = min(Rmse);
MinInterval = n1;
[m2, n2] = min(Model.PLSmodel{1,MinInterval}.RMSE);
MinRmse = m2;
Pcs = n2-1;
[vars] = GA_Code(boshu, Intervals);
Xcal_Selected(:, 1:(vars(MinInterval,2)-vars(MinInterval,1)+1)) = Xcal(:, vars(MinInterval,1):vars(MinInterval,2));
Xtest_Selected(:, 1:(vars(MinInterval,2)-vars(MinInterval,1)+1)) = Xtest(:, vars(MinInterval,1):vars(MinInterval,2));
Boshu_Selected(1:(vars(MinInterval,2)-vars(MinInterval,1)+1)) = boshu(vars(MinInterval,1):vars(MinInterval,2));
%Xcal_Selected = Xcal;
%Xtest_Selected = Ycal;
end