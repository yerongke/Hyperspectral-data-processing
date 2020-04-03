

clc

%% 导入数据
load('RAW.mat');
%  load('zz.mat', 'var_sel1')
% ZZ=var_sel1(:,:);
S_Data=RAW(:,:);

%n1=11
n = 254;   % n 是自变量的个数
m = 1;     % m 是因变量的个数
%% 读取训练数据


train_num = randperm(400);  %训练样本数
% train_Data1 = S_Data(train_num(1:300),ZZ);
% train_Data2=S_Data(train_num(1:300),255);
% train_Data=[train_Data1 train_Data2];
train_Data=S_Data(train_num(1:300),:);
% 特征值归一化
[train_Input,minI,maxI] = premnmx(train_Data(:,1:n)');
% 构造输出矩阵
[train_Output,minO,maxO] = premnmx(train_Data(:,n+1:end)');


%% 参数优化
type = 'function estimation';



%[gam,sig2]=tunelssvm({train_Data(:,1:n),train_Data(:,n+1:end),type,[],[],'RBF_kernel'},'simplex','leaveoneoutlssvm',{'mse'});

%% 参数设置
gam = 13738.1436;
sig = 124.847741;

tic; %计时开始
% 用trainlssvm()函数对训练数据进行训练
[alpha,b] = trainlssvm({train_Input',train_Output',type,gam,sig,'RBF_kernel'});
SVMtrain_Output = simlssvm({train_Input',train_Output',type,gam,sig,'RBF_kernel','preprocess'},{alpha,b},train_Input');
toc; %计时结束
train_Output = postmnmx(train_Output',minO,maxO);
SVMtrain_Output = postmnmx(SVMtrain_Output',minO,maxO);
% 训练数据误差
train_err = train_Output - SVMtrain_Output';
n1 = length(SVMtrain_Output);
train_RMSE = sqrt(sum((train_err).^2)/n1);

%% 读取测试数据
test_Data = S_Data(train_num(301:400),:);
% 特征值归一化
test_Input = tramnmx(test_Data(:,1:n)',minI,maxI)';
%[test_Input,minI1,maxI1] = premnmx(test_Data(:,1:n)');
% 构造测试输出矩阵
test_Output = tramnmx(test_Data(:,n+1:end)',minO,maxO)';
%[test_Output,minO1,maxO1] = premnmx(test_Data(:,n+1:end)');

SVMtest_Output = simlssvm({train_Input',train_Output,type,gam,sig,'RBF_kernel','preprocess'},{alpha,b},test_Input);
test_Output = postmnmx(test_Output,minO,maxO);
SVMtest_Output = postmnmx(SVMtest_Output',minO,maxO);

%% 测试数据误差
result_1 = [test_Output SVMtest_Output'];

% 测试集均方误差
E = mse(SVMtest_Output-test_Output');%E=sqrt(mse(SVMtest_Output-test_Output'));求测试集均方根误差

% 测试集决定系数
N = length(test_Output');
R2=(N*sum(SVMtest_Output.*test_Output')-sum(SVMtest_Output)*sum(test_Output'))^2/((N*sum((SVMtest_Output).^2)-(sum(SVMtest_Output))^2)*(N*sum((test_Output').^2)-(sum(test_Output'))^2));

% 测试集平均绝对误差
M=mean(abs(SVMtest_Output'-test_Output));

%% 训练数据误差
result_2 = [train_Output SVMtrain_Output'];

% 训练集均方误差
E1 =mse(SVMtrain_Output-train_Output');%E1=sqrt(mse(SVMtrain_Output-train_Output'));求训练集均方根误差

% 训练集决定系数
N1=length(train_Output');
R21=(N1*sum(SVMtrain_Output.*train_Output')-sum(SVMtrain_Output)*sum(train_Output'))^2/((N1*sum((SVMtrain_Output).^2)-(sum(SVMtrain_Output))^2)*(N1*sum((train_Output').^2)-(sum(train_Output'))^2)); 

% 训练集平均绝对误差
M1=mean(abs(SVMtrain_Output'-train_Output));

%% 结果可视化
figure(1);  
plot(1:N,SVMtest_Output,'m--+',1:N,test_Output','b-*'); 
axis([1,100,0.5,4.50]);
grid on
legend('预测值','真实值');  
ylabel('样本划分','fontsize',12);  
xlabel('样本编号','fontsize',12);  
string = {'预测集样本含量预测结果对比(LS-SVM)';['(MSE = ' num2str(E) ' R^2 = ' num2str(R2) ' MAE =' num2str(M) ')']};
title(string)

figure(2)
plot(1:N1,SVMtrain_Output,'m--+',1:N1,train_Output,'b-*');
axis([1,300,0.5,4.50]);
grid on
legend('预测值','真实值')
xlabel('样本编号')
ylabel('样本划分')
string = {'训练集样本含量预测结果对比(LS-SVM)';['(MSE = ' num2str(E1) ' R^2 = ' num2str(R21) ' MAE =' num2str(M1) ' )']};
title(string)








  

