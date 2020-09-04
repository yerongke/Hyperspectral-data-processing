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

%% ELM创建/训练
[IW,B,LW,TF,TYPE] = elmtrain(P_train,T_train,150,'sig',1);

%% ELM仿真测试
T_sim_1 = elmpredict(P_train,IW,B,LW,TF,TYPE);
T_sim_2 = elmpredict(P_test,IW,B,LW,TF,TYPE);


%% 结果对比
result_1 = [T_train' T_sim_1'];
result_2 = [T_test' T_sim_2'];
% 均方误差
E = mse(T_sim_1 - T_train);
% 决定系数
N = length(T_train);
R2=(N*sum(T_sim_1.*T_train)-sum(T_sim_1)*sum(T_train))^2/((N*sum((T_sim_1).^2)-(sum(T_sim_1))^2)*(N*sum((T_train).^2)-(sum(T_train))^2)); 


%% 绘图
figure(1)
plot(1:N-,T_test,'r-*',1:N,T_sim,'b:o')
grid on
legend('真实值','预测值')
xlabel('样本编号')
ylabel('样本划分')
string = {'测试集样本含量预测结果对比(KELM)';['(mse = ' num2str(E) ' R^2 = ' num2str(R2) ')']};
title(string)