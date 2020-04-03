load 'RAW.mat';
[m n] = size(RAW);                %m样本数，n维数
R = randperm(m);                  %1到m这些数随机打乱得到的一个随机数字序列作为索引
RAWtest = RAW(R(1:100),:);       %以索引的前100行作为测试样本RAWtest
R(1:100) = [];                    %空中括号表示删去
RAWtraining = RAW(R,:);           %剩下的数据作为训练样本RAWtraining

dataset=RAWtraining;
 %a=gaplsopt(dataset,1);
% e=gaplsopt(dataset,2);
[b,c,d]=gaplssp(dataset,100);
