% clear all
% clc
% 
% %% 训练集/测试集产生
% load('RAW.mat');
% RAW1=RAW(:,:);
% RAW=RAW1(:,1:254);
% LLL=RAW1(:,255);
% [oo, pp]=size(RAW);
% temp = randperm(oo);%训练集和预测集按照3:1分类
% X=RAW(temp(1:300),:);
% Y=LLL(temp(1:300),:);
% Xt=RAW(temp(301:end),:);
% Yt=LLL(temp(301:end),:);
% 
% %% LS-SVM分类
% % gam =      2;
% % sig2 = 0.125;
% % type = 'classification';
% %  
% % [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% % %[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel','original'});
% % %[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel','preprocess'});
% % 
% % disp(' >> Ytest = simlssvm({X,Y,type,gam,sig2,''RBF_kernel'',''preprocess''},{alpha,b},Xt);');
% % Ytest = simlssvm({X,Y,type,gam,sig2,'RBF_kernel','preprocess'},{alpha,b},Xt);
% %  
% % figure; plotlssvm({X,Y,type,gam,sig2,'RBF_kernel','preprocess'},{alpha,b});
% % 
% 
% %% LS-SVM回归
% 
% gam = 50;
% sig2 = 0.2;
% type = 'function estimation';
%  
% %[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel','original'});
% %[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel','preprocess'});
%  
% Ytest = simlssvm({X,Y,type,gam,sig2,'RBF_kernel','preprocess'},{alpha,b},Xt);
%  
% figure; plotlssvm({X,Y,type,gam,sig2,'RBF_kernel','preprocess'},{alpha,b});
% % hold off
% % Xt = (min(X):.1:max(X))'; 
% % eval('Yt = sinc(Xt);',...
% %      'Yt = sin(pi.*Xt+12345*eps)./(pi*Xt+12345*eps)+0.1.*randn(length(Xt),1);');
% % hold on;  plot(Xt,Ytest,'r-.'); hold off




% %% 测试
% clc
% 
% %% 导入数据
% 
% S_Data=load('RAW.mat');
% S_Data=RAW(:,:);
% 
% n = 254;   % n 是自变量的个数
% m = 1;     % m 是因变量的个数
% %% 读取训练数据
% train_num = 300;  %训练样本数
% train_Data = S_Data(1:train_num,:);
% 
% % 特征值归一化
% [train_Input,minI,maxI] = premnmx(train_Data(:,1:n)');%train_Data(:,1:n)'//////premnmx
% 
% % 构造输出矩阵
% [train_Output,minO,maxO] = premnmx(train_Data(:,n+1:end)');%premnmx
% 
% %% 读取测试数据
% test_Data = S_Data(train_num+1:end,:);
% % 特征值归一化
% test_Input = tramnmx(test_Data(:,1:n)',minI,maxI);
% % 构造测试输出矩阵
% test_Output = tramnmx(test_Data(:,n+1:end)',minO,maxO);
% 
% % 选取合适的参数gam
% RMSE = []; 
% Gam = 1:10:200;
% sig = 2540; 
% 
% for q = 1:20     
%     gam = Gam(1,q); %以10为步长，训练20次
%     tic;   %计时开始
%     % 用trainlssvm()函数对训练数据进行训练
%     [alpha, b] = trainlssvm({train_Input',train_Output','f',gam,sig});
%     %[alpha,b] = trainlssvm(train_Input',train_Output',gam,sig);
%     %alpha是LS-SVM的support values
%     %b是偏置项的1 x m向量
%     % sig是核宽度，gam是正则化参数
%     %gam是正则化参数:对于gam低，强调模型复杂度的最小化;对于gam高，强调训练数据点的良好拟合。
%     %kernel_par是内核的参数;在RBF核的一般情况下，较大的sig2表示较强的平滑。
%     %训练LS-SVM的支持值和偏置项，用于分类或函数逼近
%    % SVMtest_Output = simlssvm(test_Input',train_Input',alpha,b,sig);
%    [SVMtest_Output, Zt] = simlssvm({train_Input',train_Output','f',gam,sig}, test_Input');
%     %simlssvm在给定的点对LS-SVM进行评估
%     toc;   %计时结束
% 
%     test_Output = postmnmx(test_Output,minO,maxO);
%     SVMtest_Output = postmnmx(SVMtest_Output,minO,maxO);
%     
%     % 测试数据误差
%     test_err = test_Output' - SVMtest_Output;
%     n1 = length(SVMtest_Output);
%     test_RMSE = sqrt(sum((test_err).^2)/n1);
%     RMSE(1,q) = test_RMSE;
% end
% 
% x = Gam;  y = RMSE;
% plot(x,y,'-o')
% xlabel('参数gam')
% ylabel('S含量预测误差（RMSE）')

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
 gam = 30;
 sig = 0.5;
type = 'function estimation';
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



%% 分类

Yl=[l*ones(l,4),2*ones(l,4),3*ones(l,4),4*ones(l,4),5*ones(l,4)]';%训练目标值
X2=[];%测试样本数据,X2为5行20列的矩阵
Y2 =[l*ones(l,l),2*ones(l,l),3*ones(l,l),4*ones(l,l),5*ones(l,l)]’；% 测试目标值
type=‘c’;%类型为分类
kernel_type=’RBF_kerner;%核函数为径向基核函数
gam=2 ;%惩罚参数初始值
sig2=2;%核参数初始值
preprocess=’preprocess';% 数据予页处理
codefct=’code_OneVsAir;%—对多算法选择
[Yc,codebook,old_codebook]=code(Yl,codefct) %进行编码处理[gam,sig2]=tunelssvrn({Xl,Yc,type,gam,sig2,kemel_type,preprocess})% 优化参数[alpha,b]=trainlssvm({Xl,Yc,type,gam,sig2,kernel_type,preprocess})% 数据训会系Z=simlssvm({Xl,Yc,type,gam,sig2,kernel—type,preprocess},{alpha,b},X2)% 测试数据的分类
Z0 =code(Z,old-codebook,[],codebook); %绩效等级表示
Result=~abs(Z0-Y2)%显示结果,1即正确
Percent=sum(Result)/length(Result)% 测试样本数据分类正确率
[Yc,codebook,old-codebook]=code(Yl,codefct)% 进行编码处理
X0=[];%实际分类数据,X0为3行20列的矩阵
N = simlssvm({Xl,Yc,type,gam,sig2,kernel-type,preprocess}, {alpha,b},X0)% 实际数据的分类
N0 = code(N,old_codebook,[],codebook)% 绩效等级表示




  

