function [out1] = sa_decode(Xcal_new, Ycal, Xtest_new, Ytest , boshu, k)
%本函数的功能是对优选出来的染色体进行解码，得出rc,RMSEC，rp,RMSEP等建模结果

    plot(boshu, Xcal_new);
    Model=ipls_my(Xcal_new, Ycal, k, 'mean', 1, boshu, 'syst123', 5);%%修改了IPLS函数，使其不显示处理进度
    rmse = Model.PLSmodel{1}.RMSE;
    [temp_rmse, topj] = min(rmse);
    plspvsm(Model,topj-1,1);
    oneModel=plsmodel(Model,1,topj-1,'auto','test',5);
    predModel=plspredict(Xtest_new,oneModel,topj-1,Ytest);
    plspvsm(predModel,topj-1,1);

    out1 = 1;

end