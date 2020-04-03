load 'RAW.mat';
[m n] = size(RAW);   %m样本数，n维数
y=RAW(:,1:n-1);
y_m=mean(y);
y_MSC=msc(y,y_m);
labol=RAW(:,n);
C=[y_MSC labol];
R = randperm(m);                  %1到m这些数随机打乱得到的一个随机数字序列作为索引
RAWtest = C(R(1:100),:);       %以索引的前100行作为测试样本RAWtest
R(1:100) = [];                    %空中括号表示删去
RAWtraining = C(R,:);           %剩下的数据作为训练样本RAWtraining
X=RAWtraining(:,1:n-1);
y=RAWtraining(:,n);
%  F=carspls(X,y);
% plotcars(F);

% plotmcs(F);
%F=randomfrog_plslda(X,y);




% load ('LPCS.mat');
% 
% [m n] = size(A);                %m样本数，n维数
% R = randperm(m);                  %1到m这些数随机打乱得到的一个随机数字序列作为索引
% Atest = A(R(1:15),:);       %以索引的前100行作为测试样本Atest
% R(1:15) = [];                    %空中括号表示删去
% Atraining = A(R,:);           %剩下的数据作为训练样本Atraining
% X=Atraining(:,1:n-1);
% y=Atraining(:,n);
% F=carspls(X,y);
% plotcars(F);