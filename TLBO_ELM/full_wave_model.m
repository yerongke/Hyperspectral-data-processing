clear all
clc

%% 训练集/测试集产生
load('DOSC.mat');
RAW=DOSC(:,1:254);
LLL=DOSC(:,255);
P_train = RAW(1:315,:)';
T_train = LLL(1:315,:)';
P_test = RAW(316:end,:)';
T_test = LLL(316:end,:)';

%% ELM创建/训练
[IW,B,LW,TF,TYPE] = elmtrain(P_train,T_train,130,'sig',1);

%% ELM仿真测试
T_sim_1 = elmpredict(P_train,IW,B,LW,TF,TYPE);
T_sim_2 = elmpredict(P_test,IW,B,LW,TF,TYPE);

%% 结果对比
result_1 = [T_train' T_sim_1'];
result_2 = [T_test' T_sim_2'];
% 训练集正确率
k1 = length(find(T_train == T_sim_1));
n1 = length(T_train);
Accuracy_1 = k1 / n1 * 100;
disp(['训练集正确率Accuracy = ' num2str(Accuracy_1) '%(' num2str(k1) '/' num2str(n1) ')'])
% 测试集正确率
k2 = length(find(T_test == T_sim_2));
n2 = length(T_test);
Accuracy_2 = k2 / n2 * 100;
disp(['测试集正确率Accuracy = ' num2str(Accuracy_2) '%(' num2str(k2) '/' num2str(n2) ')'])