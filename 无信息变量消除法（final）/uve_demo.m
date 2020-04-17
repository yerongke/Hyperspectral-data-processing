clear all
clc

%% 训练集/测试集产生
load('RAW.mat');
RAW1=RAW(:,:);
RAW=RAW1(:,1:254);
LLL=RAW1(:,255);
[oo, pp]=size(RAW);
temp = randperm(oo);%训练集和预测集按照3:1分类
P_train = RAW(temp(1:300),:);
T_train = LLL(temp(1:300),:);
P_test = RAW(temp(301:end),:);
T_test = LLL(temp(301:end),:);
X=RAW(:,:);
y=LLL(:,:);

%% 无信息变量消除法实现
[mean_b,std_b,t_values,var_retain,RMSECVnew,Yhat,E]=plsuve(X,y,10,400,254);%10是最佳因子数，400是留一法的次数，一般取样本数，254是加入的随机噪声的波段数，可以取等值也就是样本波段数，其他的参数不用设置