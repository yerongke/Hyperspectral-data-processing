clear ;close all;
clc;
load RAW.mat; 
%RAW=RAW(:,1:254);


%%连续投影算法（SPA）提取特征波长，Xcal是训练集，无标签；Xval是验证集，无标签；ycal是训练集的标签；yval是验证集的标签。

%先把标签给放回来
z=RAW(:,255);
y_SPA_RAW=[y_MSC,z];


%%第一种标签，每100行一个标签
% [m n] = size(y_SPA_RAW);                %m样本数，n维数
% R = randperm(m);                  %1到m这些数随机打乱得到的一个随机数字序列作为索引
% RAWtest = y_SPA_RAW(R(1:100),:);       %以索引的前100行作为测试样本RAWtest
% R(1:100) = [];                    %空中括号表示删去
% RAWtraining = y_SPA_RAW(R,:);           %剩下的数据作为训练样本RAWtraining
% RAW_c=RAWtraining(:,1:n-1);
% RAW_v=RAWtest(:,1:n-1);
% RAWc=RAWtraining(:,n);
% RAWv=RAWtest(:,n);
% Xcal=RAW_c;
% ycal=RAWc;
% Xval=RAW_v;
% yval=RAWv;

[m n] = size(y_SPA_RAW);                %m样本数，n维数
R = randperm(m);                      %1到m这些数随机打乱得到的一个随机数字序列作为索引
RAWtest = y_SPA_RAW(R(1:100),:);       %以索引的前100行作为测试样本RAWtest
R(1:100) = [];                        %空中括号表示删去
RAWtraining = y_SPA_RAW(R,:);           %剩下的数据作为训练样本RAWtraining
[m1 n1]=size(RAWtraining);
R1 = randperm(m1); 
RAWtest1 = RAWtraining(R1(1:75),:);
R1(1:75) = [];   
RAWtraining1 = RAWtraining(R1,:);

RAW_c=RAWtraining1(:,1:n1-1);
RAW_v=RAWtest1(:,1:n1-1);
RAWc=RAWtraining1(:,n1);
RAWv=RAWtest1(:,n1);
Xcal=RAW_c;
ycal=RAWc;
Xval=RAW_v;
yval=RAWv;





% %%第二种标签，前300行为1，后100行为2
% load('RAW_another.mat');
% [m n] = size(RAW_another);                             %m样本数，n维数
% R = randperm(m);                                       %1到m这些数随机打乱得到的一个随机数字序列作为索引
% RAW_anothertest = RAW_another(R(1:100),:);             %以索引的前100行作为测试样本RAW_anothertest
% R(1:100) = [];                                         %空中括号表示删去
% RAW_anothertraining = RAW_another(R,:);                %剩下的数据作为训练样本RAW_anothertraining
% RAW_another_c=RAW_anothertraining(:,1:n-1);
% RAW_another_v=RAW_anothertest(:,1:n-1);
% RAW_anotherc=RAW_anothertraining(:,n);
% RAW_anotherv=RAW_anothertest(:,n);
% Xcal=RAW_another_c;
% ycal=RAW_anotherc;
% Xval=RAW_another_v;
% yval=RAW_anotherv;
% 
% 
% 
% RAW_spa=spa(Xcal,ycal,Xval,yval,5,20,1);%可以调用spa函数，特征波长选择最少5个，最多不限，选择自动校准,自动校准（autoscaling）选择1，否则选择0
% 
m_min=5;
m_max=50;

N = size(Xcal,1); %Xcal的行数，也就是样本数
K = size(Xcal,2); %Xcal的列数，也就是维数


% Phase 1: Projection operations for the selection of candidate subsets选择候选子集的投影运算
    
normalization_factor = std(Xcal);%求Xcal的标准偏差，也就是标准化因子，化数据为一行。标准化的作用：标准化之后使不同的特征具有相同的尺度
    
for k = 1:K
    x = Xcal(:,k);
    Xcaln(:,k) = (x - mean(x)) / normalization_factor(k); %每一列数据减去平均值除以标准差，就是标准差标准化（标准化）
end


SEL = zeros(m_max,K);%全零矩阵，方便填入数据
for k = 1:K
    SEL(:,k) = projection(Xcaln,k,m_max);  %选择出的投影
end

% Phase 2: Evaluation of the candidate subsets according to the PRESS criterion  根据press准则评价候选子集
% PRESS (Prediction Errors Sum of Squares)（预测误差平方和）

PRESS = Inf*ones(m_max,K);  %Inf是无穷大量，避免有除以0的情况

for k = 1:K
    for m = m_min:m_max
        var_sel = SEL(1:m,k);
        [yhat1,e1] = validation(Xcal,ycal,Xval,yval,var_sel); %e1为验证错误，训练集和验证集没有交叉，所以不是交叉验证
        PRESS(m,k) = e1'*e1;%转置乘以原矩阵，是（验证集的样本数×验证集的样本数）大小
    end
end

[PRESSmin,m_sel] = min(PRESS);  %找出每列预测误差平方和最小值（PRESS），返回所在行（波段数）（m_sel），先找出每列里的最小值
[dummny,k_sel] = min(PRESSmin); %找到矩阵里预测误差平方和最小值（dummny），其所在的列（k_sel)，列里面存放的是波段数，再找出所有的最小值

%第k_sel波段为初始波段时最佳，波段数目为m_sel(k_sel)
var_sel_phase2 = SEL(1:m_sel(k_sel),k_sel); 

% Phase 3: Final elimination of variables 变量的最终消除

% Step 3.1: Calculation of the relevance index 关联指数的计算
Xcal2 = [ones(N,1) Xcal(:,var_sel_phase2)]; %第一列为1，其他选择出来的波段为其他列
b = Xcal2\ycal; % MLR with intercept term  带截距项的多元线性回归，验证集的标签除以选择出来的波段，也就是乘以逆矩阵
std_deviation = std(Xcal2);%标准误差，标准偏差
relev = abs(b.*std_deviation');%关联，求绝对值,而且是点乘，不是矩阵相乘
relev1 = relev(2:end);%把第一行0给删除
% Sorts the selected variables in decreasing order of "relevance"  按“相关性”的降序排列所选变量
[dummy,index_increasing_relev] = sort(relev1);%排序函数sort，dummy是排序之后的，index_increasing_relev增加的关联代表行数
index_decreasing_relev = index_increasing_relev(end:-1:1);%把顺序反过来，从关联大的到关联小的

% Step 3.2: Calculation of PRESS values  步骤3.2：压力值计算
for i = 1:length(var_sel_phase2)
    [yhat2,e2] = validation(Xcal,ycal,Xval,yval,var_sel_phase2(index_decreasing_relev(1:i)) );%标签的验证误差，e2为验证错误
    PRESS_scree(i) = e2'*e2;
end
RMSEP_scree = sqrt(PRESS_scree/length(e2));%预测均方根误差是是预测误差平方和除以长度在开平方
figure(12);
grid, hold on;
plot(RMSEP_scree);
xlabel('Number of variables included in the model'); %模型中包含的变量数量
ylabel('RMSE'); %均方根误差亦称标准误差，其定义为 ，i=1，2，3，…n。在有限测量次数中，均方根误差常用下式表示：√[∑di^2/n]=Re，
                %式中：n为测量次数；di为一组测量值与真值的偏差。
 
% Step 3.3: F-test criterion  f检验准则
PRESS_scree_min = min(PRESS_scree);
alpha = 0.25;
dof = length(e2); % Number of degrees of freedom 自由度
fcrit = finv(1-alpha,dof,dof); % Critical F-value 临界f值，F累积分布函数的倒数,也就是分位点
PRESS_crit = PRESS_scree_min*fcrit;
% Finds the minimum number of variables for which PRESS_scree
% is not significantly larger than PRESS_scree_min  查找按scree键的最小变量数不明显大于Press-Scree-Min
zx=find(PRESS_scree < PRESS_crit);
i_crit = min(zx); %找到最小的列数
i_crit = max(m_min,i_crit); %取最小的列数和需要的特征波长的个数的最大值

var_sel1 = var_sel_phase2( index_decreasing_relev(1:i_crit) );%最终确定的特征波长个数及所在的波段
title(['Final number of selected variables: ' num2str(length(var_sel1)) '  (RMSE = ' num2str(RMSEP_scree(i_crit)) ')'],'FontSize',13);
%选定变量的最终数目   均方根误差（RMSE)的数值
% Indicates the selected point on the scree plot  指示树状图上的选定点
hold on;
plot(i_crit,RMSEP_scree(i_crit),'s');


% Presents the selected variables   显示选定的变量
% in the first object of the calibration set 在校准集的第一个对象中
figure(13),plot(Xcal(1,:));
hold,grid;
plot(var_sel1,Xcal(1,var_sel1),'s')   %随便选择一行来显示，这里选择的是第10个样本
legend('First calibration object','Selected variables')%第一训练对象   选定变量
xlabel('Variable index','FontSize',12) %变量索引
ylabel('Refelctance','FontSize',12);