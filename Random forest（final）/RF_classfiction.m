clear all
clc

%% 训练集/测试集产生
load('snv_uve.mat');

CARS=snv_uve(:,1:87);
LLL=snv_uve(:,88);

P_train = CARS(1:315,:);
T_train = LLL(1:315,:);
P_test = CARS(316:end,:);
T_test = LLL(316:end,:);
%% 创建随机森林分类器
% P=CARS(:,:);
% T=LLL(:,:);
model = classRF_train(P_train,T_train);
%% 仿真测试
[T_sim_1,votes1] = classRF_predict(P_train,model);
[T_sim_2,votes2] = classRF_predict(P_test,model);
%% 获得随机森林
ctree=ClassificationTree.fit(P_train,T_train);
%% 随机森林试图
 view(ctree);
view(ctree,'mode','graph');

%% 十字交叉验证
leafs=logspace(1,2,10);%表示10的1次方到10的2次方等分成10份
N=numel(leafs);
err=zeros(N,1);
for n=1:N
t=ClassificationTree.fit(P_train,T_train,'crossval','on','minleaf',leafs(n));
err(n)=kfoldLoss(t);
end
figure(1)
plot(leafs,err);

%% 结果对比
T_train=T_train';
T_sim_1=T_sim_1';
T_test=T_test';
T_sim_2=T_sim_2';
result_1 = [T_train' T_sim_1'];
result_2 = [T_test' T_sim_2'];

result_1_1=sortrows(result_1,1);
result_2_1=sortrows(result_2,1);

a1=result_1_1(:,1)';
a2=result_1_1(:,2)';
a3=result_2_1(:,1)';
a4=result_2_1(:,2)';

%% 训练集正确率
k1 = length(find(T_train== T_sim_1));
n1 = length(T_train);
Accuracy_1 = k1 / n1 * 100;
disp(['训练集正确率Accuracy = ' num2str(Accuracy_1) '%(' num2str(k1) '/' num2str(n1) ')'])

%% 测试集正确率
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
figure(2)
plot(1:315,a1,'r-*',1:315,a2,'b-.o')
axis([0,316,0.5,7.5]);
grid on
xlabel('Prediction set')
ylabel('Calibration set')
string = {'训练集预测结果对比(ELM)';['(正确率Accuracy = ' num2str(Accuracy_1) '%)' ]};
title(string)
legend('Reference category','Prediction category')

figure(3)
plot(1:105,a3,'r-*',1:105,a4,'b-.o')
axis([0,106,0.5,7.5]);
grid on
xlabel('Prediction set')
ylabel('Calibration set')
string = {'测试集预测结果对比(ELM)';['(正确率Accuracy = ' num2str(Accuracy_2) '%)' ]};
title(string)
legend('Reference category','Prediction category')
