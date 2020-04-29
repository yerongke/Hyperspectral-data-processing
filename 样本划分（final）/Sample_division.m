clear all
clc

%% 训练集/测试集产生
RAW=xlsread('xia.xlsx');
X=RAW(2:end,1:254);
Y=RAW(2:end,255);
[m,dminmax] =spxy(X,Y,315);
%[m,dminmax] = KS(X,300);
a=randperm(420);
b=setdiff(a,m);%求两个矩阵的异或
RAW1=RAW(m,:);
RAW2=RAW(b,:);
xia=[RAW1;RAW2];