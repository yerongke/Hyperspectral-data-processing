clear all
clc

%% 训练集/测试集产生
load('CARS.mat');
CARS1=CARS(:,:);
CARS=CARS1(:,1:29);
LLL=CARS1(:,30);

P_train = CARS(1:315,:)';
T_train = LLL(1:315,:)';
P_test = CARS(316:end,:)';
T_test = LLL(316:end,:)';

%% ELM创建/训练
[IW,B,LW,TF,TYPE] = elmtrain(P_train,T_train,170,'sig',1);

%% ELM仿真测试
T_sim_1 = elmpredict(P_train,IW,B,LW,TF,TYPE);
T_sim_2 = elmpredict(P_test,IW,B,LW,TF,TYPE);

%% 结果对比
result_1 = [T_train' T_sim_1'];
result_2 = [T_test' T_sim_2'];
result_1_1=sortrows(result_1,1);
result_2_1=sortrows(result_2,1);
a1=result_1_1(:,1)';
a2=result_1_1(:,2)';
a3=result_2_1(:,1)';
a4=result_2_1(:,2)';
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

%% 绘图一
% figure(1)
% plot(1:315,T_train,'bo',1:315,T_sim_1,'r-*')
% axis([1,315,0.5,7.5]);
% grid on
% xlabel('训练集样本编号')
% ylabel('训练集集样本类别')
% string = {'训练集预测结果对比(ELM)';['(正确率Accuracy = ' num2str(Accuracy_1) '%)' ]};
% title(string)
% legend('真实值','ELM预测值')
% 
% figure(2)
% plot(1:105,T_test,'bo',1:105,T_sim_2,'r-*')
% axis([1,105,0.5,7.5]);
% grid on
% xlabel('测试集样本编号')
% ylabel('测试集样本类别')
% string = {'测试集预测结果对比(ELM)';['(正确率Accuracy = ' num2str(Accuracy_2) '%)' ]};
% title(string)
% legend('真实值','ELM预测值')

%% 绘图二
figure(1)
plot(1:315,a1,'r-*',1:315,a2,'b-.o')
axis([0,316,0.5,7.5]);
grid on
xlabel('Prediction set')
ylabel('Calibration set')
string = {'训练集预测结果对比(ELM)';['(正确率Accuracy = ' num2str(Accuracy_1) '%)' ]};
title(string)
legend('Reference category','Prediction category')

figure(2)
plot(1:105,a3,'r-*',1:105,a4,'b-.o')
axis([0,106,0.5,7.5]);
grid
xlabel('测试集样本编号')
ylabel('测试集样本类别')
string = {'测试集预测结果对比(ELM)';['(正确率Accuracy = ' num2str(Accuracy_2) '%)' ]};
title(string)
legend('Reference category','Prediction category')