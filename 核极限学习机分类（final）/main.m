
clc;clear

load RAW
data=RAW;

[row,col]=size(data);
x=data(:,1:col-1);
y=data(:,col);

% x=mxColWiseNorm(x); %normalized
% % y=mxColWiseNorm(y);
% y=y.*2-1;

[Xrow,Xcol]=size(x);

inx=randperm(Xrow);
% 
x=x(inx,:);
y=y(inx,:);


part=0.75;
X=x(1:ceil(Xrow*part),:);
Y=y(1:ceil(Xrow*part),:);

XT=x(ceil(Xrow*part)+1:end,:);
YT=y(ceil(Xrow*part)+1:end,:);

if numel(unique(Y))~=numel(unique(YT))
    error('features of training set and testing set not match');
end
%-------------------------------------------------------------------------
TrainingLData=[Y,X];
TestingData=[YT,XT];
% TestingData=TestingData(1:15,:);
trialNum=100;
trainAccuary=zeros(trialNum,1);
testAccuary=zeros(trialNum,1);
TrainingTime=zeros(trialNum,1);
TestingTime=zeros(trialNum,1);
%-------------------------------------------------------------------------

C=10^9;
%保持随机过程不变
% rand('state',1);


for ii=1:trialNum

%  [TrainingTime(ii), TestingTime(ii), trainAccuary(ii), testAccuary(ii)] = elm_kernel(TrainingLData, TestingData, 1, 10^3, 'RBF_kernel',1);
 model = elm_kernel_train(TrainingLData,C,'RBF_kernel',10);
 Output1 = elm_kernel_test(TrainingLData, model);
 Output2 = elm_kernel_test(TestingData, model);
 TrainingTime(ii)=model.TrainingTime;
 TestingTime(ii)=Output2.TestingTime;
 trainAccuary(ii)=Output1.TestingAccuracy;
 testAccuary(ii)=Output2.TestingAccuracy;
end

aveTrainingTime=mean(TrainingTime);
aveTestingTime=mean(TestingTime)
avetrainAccuary=sum(trainAccuary)/trialNum
vartrainAccuary=var(trainAccuary)
avetestAccuary=sum(testAccuary)/trialNum
vartestAccuary=var(testAccuary)

num=1:trialNum;
num=num';
Title={'TrainingTime','TestingTime','trainAccuary',' testAccuary'};
A=[num,TrainingTime,TestingTime,trainAccuary, testAccuary];
C=sprintf('aveTrainingTime:%f\r\naveTestingTime:%f\r\naveTrainingAccuary:%f\r\naveTestingAccuracy:%f\r\nTrainingVar:%f\r\nTestingVar:%f\r\n',...
    aveTrainingTime,aveTestingTime,avetrainAccuary,avetestAccuary,vartrainAccuary,vartestAccuary)

% R={Title;A;C}
xlswrite('Result.xls',A);

