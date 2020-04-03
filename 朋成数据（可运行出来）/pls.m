clc
load('var.mat');
load('var_ch.mat');
var_x=var(:,:);
var_y=var_ch(:,:);
var=[var_x(1:19,:),var_y(1:19,:)];
mu=mean(var);sig=std(var); %求均值和标准差
rr=corrcoef(var);   %求相关系数矩阵
ab=zscore(var); %数据标准化
a=ab(:,[1:1781]);b=ab(:,[1782:end]);  %提出标准化后的自变量和因变量数据
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] =plsregress(a,b);
xw=a\XS;  %求自变量提出成分系数
yw=b\YS;  %求因变量提出成分的系数
a_0=PCTVAR(1,:);b_0=PCTVAR(2,:);%PCTVAR是一个两行的矩阵，第一行为自变量提取成分的贡献率，第二行为因变量提取成分的贡献率
a_1=cumsum(a_0);b_1=cumsum(b_0);
i=1;
%判断提出成分对的个数
while ((a_1(i)<0.95)&&(a_0(i)>0.05)&&(b_1(i)<0.95)&&(b_0(i)>0.05))
    i=i+1;
end
ncomp=i;
fprintf('主成分个数为：%d\n',ncomp);
fprintf('%d对成分分别为：\n',ncomp);
for i=1:ncomp
    fprintf('第%d对成分：\n',i);
    fprintf('u%d=',i);
    for k=1:1781%此处为变量x的个数
        fprintf('+(%f*x_%d)',xw(k,i),k);
    end
    fprintf('\n');
        fprintf('v%d=',i);
    for k=1:3%此处为变量y的个数
        fprintf('+(%f*y_%d)',yw(k,i),k);
    end
    fprintf('\n');
end
[XL2,YL2,XS2,YS2,BETA2,PCTVAR2,MSE2,stats2] =plsregress(a,b,ncomp);
n=size(a,2); m=size(b,2); %n是自变量的个数,m是因变量的个数
beta3(1,:)=mu(n+1:end)-mu(1:n)./sig(1:n)*BETA2([2:end],:).*sig(n+1:end); %原始数据回归方程的常数项
beta3([2:n+1],:)=(1./sig(1:n))'*sig(n+1:end).*BETA2([2:end],:); %计算原始变量的系数，每一列是一个回归方程
fprintf('最后得出如下回归方程：\n')
for i=1:3%此处为变量y的个数
    fprintf('y%d=%f',i,beta3(1,i));
    for j=1:1781%此处为变量x的个数
        fprintf('+(%f*x%d)',beta3(j+1,i),j);
    end
    fprintf('\n');
end
c=var_x(20:24,:);d=var_y(20:24,:);
for i=1:5
    predict(i,:)=(sum(beta3(2:end,:)'.*c(i,:),2)+beta3(1,:)')';
end
fprintf('预测2020-2025年的结果：\n');
disp(predict)
