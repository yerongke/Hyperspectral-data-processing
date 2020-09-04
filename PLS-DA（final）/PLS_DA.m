function [ccr,cvr,ypredict,ycredict,yc,yp,ys]=PLS_DA(x1,y1,x2,y2,lv)
%偏最小二乘线性判别程序
% 输入变量
% x1:建模集的特征，行为样本序号，列为特征序号；
% y1:建模集的类别，行为样本序号，列为类别序号，样本属于哪类则该类序号下这个样本
% 的值为1，其他列的值为0。例如，y1的第2行=[1 0 0]指第2个样本属于第1类，样本集
% 共分为3个类别
% x2：预测集或检验集的特征；y2：预测集的类别数组；lv:为潜变量个数
% 输出变量
% yp：模型给出的检验集样本的y值
[n1,m1]=size(x1);%将训练集样本数赋给n1，变量数赋给m1
[n2,m2]=size(x2);%将检验集样本数赋给n2，变量数赋给m2
nj=size(y1,2);%将训练集类别数赋给nj
ny=size(y2,2);%将检验集类别数赋给ny
if nj ~= ny
    error('训练集与检验集变量个数必须相等')
end
if lv > m1
    error('潜变量个数不能大于特征变量个数')
end
ys=[];
ypredict=zeros(n2,nj);%开一个行数=检验集样本数、列数=类别数、元素值=0的数组 
% ypredict 以存放模型判别的检验集样本类别信息
ycredict=zeros(n1,nj);%开一个行数=建模集样本数、列数=类别数、元素值=0的数组 
% ypredict 以存放模型判别的检验集样本类别信息
yp=[];
yc=[];
hindexv=[];
hindexc=[];
for j=1:nj
    [theta,yres]=plsr(x1,y1(:,j),m1,lv);
    yre=mean(abs(yres));
    myre=mean(yre,2);
    ys=[ys myre];%将建模集的平均偏差赋给ys
    ayc=x1*theta';%计算模型给出的建模集样本的y值并赋给ayc
    ayp=x2*theta';%计算模型给出的检验集样本的y值ayp
    yc=[yc ayc];%将模型给出的建模集样本的y值赋给yc
    yp=[yp ayp];%将模型给出的检验集样本的y值赋给yp
end
for jj=1:nj
    for i=1:n2
        if yp(i,jj) > 0.5 & ys(1,jj) < 0.5
            ypredict(i,jj)=1;
        elseif yp(i,jj) >= 0.5 & ys(1,jj)>0.5
            ypredeict(i,jj)=2;
        else
            ypredict(i,jj)=0;
        end
    end
end
a=find(ypredict(:,:)>1);
hindexv=[hindexv;a];
yactv=y2; %将检验集的类别信息赋给yactv
yactv(hindexv,:)=[]; %将检验集中灰色样本所在行定义为空
hypr=y2(hindexv,:);%将检验集中灰色样本的类别信息赋给 hypr
ypp=ypredict; %将模型判别的检验类别的检验集类别信息赋给ypp
ypp(hindexv,:)=[]; %将ypp中灰色样本所在行定义为空
b=size(hypr,1); %统计检验集中灰色样本的个数
d=n2-b;%统计模型可明确判别类别的检验样本个数并赋给d
c=ones(d,1);%开一个行为d、元素值为1的列向量c
ccv=c;
for kk=1:d
    for jjj=1:nj
        if yactv(kk,jjj)~=ypp(kk,jjj)
            ccv(kk,1)=0; %若模型判别的检验集样本类别与实际类别不同则 ccv=0
        end
    end
end
cvr=sum(ccv)/sum(c); %计算模型对检验集样本判别的正确并赋给cvr
for jj=1:nj
    for i=1:n1
        if yc(i,jj)>0.5 & ys(1,jj)<0.5
            ycredict(i,jj)=1;
        elseif yc(i,jj) >=0.5 & ys(1,jj)>0.5
            ycredict(i,jj)=0;
        end
    end
end
a=find(ycredict(:,:)>1);
hindexc=[hindexc;a];
yact=y1; %将训练集中灰色样本所在行定义为空
hypr=y2(hindexc,:);%将训练集中灰色样本的类别信息赋给hypr
ycp=ycredict;%将模型判别的训练类别信息赋给ycp
ycp(hindexc,:)=[];%将ycp中灰色样本所在行定义为空
b=size(hypr,1);%统计模型判别为灰色样本的训练集样本个数
d=n1-b;%统计模型可明确判别类别的训练集样本个数并赋给d
c=ones(d,1);%开一个行为d,元素值为1的列向量c
cc=c;
for kk=1:d
    for jjj=1:nj
        if yact(kk,jjj)~=ycp(kk,jjj)
            cc(kk,1)=0; %若模型判别的训练集样本类别与实际类别不同则cc=0
        end
    end
end
ccr=sum(cc)/sum(c);%计算模型对训练集样本判别的正确并赋给ccr
% end of the M file