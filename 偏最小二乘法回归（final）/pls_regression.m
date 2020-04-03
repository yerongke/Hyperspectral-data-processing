clc;
clear;
%% 数据导入

load('RAW.mat');
RAW1=RAW(:,:);
RAW=RAW1(:,1:254);
LLL=RAW1(:,255);
[oo, pp]=size(RAW);
temp = randperm(oo);
data_train = RAW(temp(1:300),:);
target_out = LLL(temp(1:300),:);
data_predict = RAW(temp(301:end),:);
predict_out = LLL(temp(301:end),:);


%% 数据处理
var=[data_train,target_out];
mu=mean(var);  %求均值
sig=std(var);  %求标准差
rr=corrcoef(var);   %求相关系数矩阵
ab=zscore(var); %数据标准化
a=ab(:,[1:254]);b=ab(:,end);  %提出标准化后的自变量和因变量数据
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] =plsregress(a,b);
xw=a\XS;  %求自变量提出成分系数
yw=b\YS;  %求因变量提出成分的系数
a_0=PCTVAR(1,:);b_0=PCTVAR(2,:);%PCTVAR是一个两行的矩阵，第一行为自变量提取成分的贡献率，第二行为因变量提取成分的贡献率
a_1=cumsum(a_0);b_1=cumsum(b_0);

%% 判断提出成分对的个数
i=1;
while ((a_1(i)<0.95)&&(a_0(i)>0.05)&&(b_1(i)<0.95)&&(b_0(i)>0.05))
    i=i+1;
end
ncomp=i;
fprintf('主成分个数为：%d\n',ncomp);
fprintf('%d对成分分别为：\n',ncomp);
for i=1:ncomp
    fprintf('第%d对成分：\n',i);
    fprintf('u%d=',i);
    for k=1:254  %此处为变量x的个数
        fprintf('+(%f*x_%d)',xw(k,i),k);
    end
    fprintf('\n');
        fprintf('v%d=',i);
    for k=1  %此处为变量y的个数，假如因变量是3个的话就要写成1:3
        fprintf('+(%f*y_%d)',yw(k,i),k);
    end
    fprintf('\n');
end


%% 训练集预测值及回归方程
[XL2,YL2,XS2,YS2,BETA2,PCTVAR2,MSE2,stats2] =plsregress(a,b,ncomp);
n=size(a,2); m=size(b,2); %n是自变量的个数,m是因变量的个数
beta3(1,:)=mu(n+1:end)-mu(1:n)./sig(1:n)*BETA2([2:end],:).*sig(n+1:end); %原始数据回归方程的常数项
beta3([2:n+1],:)=(1./sig(1:n))'*sig(n+1:end).*BETA2([2:end],:); %计算原始变量的系数，每一列是一个回归方程
%直方图
bar(BETA2','b');%BETA2为回归模型的系数
%y的预测值
yhat = repmat(beta3(1),[size(a,1),1]) + var(:,1:n)*beta3(2:end,:);
fprintf('最后得出如下回归方程：\n')

%rcoplot(XS2,YS2);画残差图，但没做出来，标准格式为[b,bint,r,rint,stats]=regress(y,x)；rcoplot(r,rint)；rcoplot(r,rint)函数使用来画 regress()拟合后的数据残差图的，能用其辨别出个别的离群点。
%其中 r和 rint是regress()的两个返回值。r代表残差，rint代表各个数据点相应的95%置信区间。
%用rcoplot()作图后如果存在红颜色的竖条，表明该点为离群点。

%% 预测集预测值
for i=1 %此处为变量y的个数，假如因变量是3个的话就要写成1:3
    fprintf('y%d=%f',i,beta3(1,i));
    for j=1:254 %此处为自变量x的个数
        fprintf('+(%f*x%d)',beta3(j+1,i),j);
    end
    fprintf('\n');
end
c=data_predict;
d=predict_out;
for i=1:100  %预测集样本数
    predict(i,:)=(sum(beta3(2:end,:)'.*c(i,:),2)+beta3(1,:)')';
end
%fprintf('预测结果：\n');
%disp(predict)

%% 训练数据误差
result_2 = [target_out yhat];

% 训练集均方误差
E1 =mse(yhat'-target_out');%E1=sqrt(mse(yhat-data_train'));求训练集均方根误差

% 训练集决定系数
N1=length(target_out');
R21=(N1*sum(yhat'.*target_out')-sum(yhat')*sum(target_out'))^2/((N1*sum((yhat').^2)-(sum(yhat'))^2)*(N1*sum((target_out').^2)-(sum(target_out'))^2)); 

% 训练集平均绝对误差
M1=mean(abs(yhat'-target_out'));

%% 测试数据误差
result_1 = [predict_out predict];

% 测试集均方误差
E = mse(predict'-predict_out');%E=sqrt(mse(predict-predict_out'));求测试集均方根误差

% 测试集决定系数
N = length(predict_out');
R2=(N*sum(predict'.*predict_out')-sum(predict')*sum(predict_out'))^2/((N*sum((predict').^2)-(sum(predict'))^2)*(N*sum((predict_out').^2)-(sum(predict_out'))^2));

% 测试集平均绝对误差
M=mean(abs(predict'-predict_out'));


%% 结果可视化(折线图）
figure(2);  
plot(1:N,predict,'m--+',1:N,predict_out','b-*'); 
axis([1,100,0.5,5]);
grid on
legend('预测值','真实值');  
ylabel('样本划分','fontsize',12);  
xlabel('样本编号','fontsize',12);  
string = {'预测集样本含量预测结果对比(pls)';['(MSE = ' num2str(E) ' R^2 = ' num2str(R2) ' MAE =' num2str(M) ')']};
title(string)

figure(3)
plot(1:N1,yhat,'m--+',1:N1,target_out,'b-*');
axis([1,300,0.5,5]);
grid on
legend('预测值','真实值')
xlabel('样本编号')
ylabel('样本划分')
string = {'训练集样本含量预测结果对比(pls)';['(MSE = ' num2str(E1) ' R^2 = ' num2str(R21) ' MAE =' num2str(M1) ' )']};
title(string)


%% 结果可视化（拟合图）
%yhat=sort(yhat);
y1max=max(yhat);%求预测值的最大值
y2max=max(target_out);%求观测值的最大值
ymax=max([y1max;y2max]);%求预测值和观测值的最大值
cancha=yhat-target_out;%计算残差
figure(4)
plot(0:ymax(1),0:ymax(1),yhat(:,1),target_out(:,1),'c*');
title('训练集拟合')


y11max=max(predict);%求预测值的最大值
y22max=max(predict_out);%求观测值的最大值
y1max=max([y11max;y22max]);%求预测值和观测值的最大值
cancha1=predict-predict_out;%计算残差
figure(5)
plot(0:y1max(1),0:y1max(1),predict(:,1),predict_out(:,1),'mx');
title('预测集拟合')

%% 做残差图分析回归拟合情况
[b4,bint4,r4,rint4,stats4]=regress(yhat,target_out);
figure(6)
rcoplot(r4,rint4);
[b3,bint3,r3,rint3,stats3]=regress(predict,predict_out);
figure(7)
rcoplot(r3,rint3);








