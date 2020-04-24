clear all
clc

%% 训练集/测试集产生
load('RAW.mat');
RAW1=RAW(:,:);
RAW=RAW1(:,1:254);
LLL=RAW1(:,255);
[oo, pp]=size(RAW);
temp = randperm(oo);%训练集和预测集按照3:1分类
P_train = RAW(temp(1:300),:)';
T_train = LLL(temp(1:300),:)';
P_test = RAW(temp(301:end),:)';
T_test = LLL(temp(301:end),:)';
X=RAW(:,:);
y=LLL(:,:);

%% 间隔随机青蛙算法
F=irf(X,y,1000,5);
A=find(F.probability>0.7);%设置阈值，超过阈值的就是想要的特征波长
figure(1)
bar(F.probability,'b','edgecolor','w');
hold on
plot([0,254],[0.7,0.7],'r-');
xlabel('variable index');
ylabel('selection probability');
xlim([0 255]);
figure(2)
bar(F.RMSECV,'c','edgecolor','w');