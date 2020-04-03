function plotcars(F)
%%% F is the returned structural data obtained from arsplslda.m. 
%%% This function is to plot the result.
%+++ Hongdong Li, Jan 15, 2009.


W=F.W;
RMSEP=F.cv;
indexOPT=F.iterOPT;
num=length(RMSEP);

subplot(311);
for i=1:num;L(i)=length(find(W(:,i)~=0));end
plot(L,'linewidth',1.5);
xlabel('Number of sampling runs');ylabel('Number of sampled variables');
subplot(312);
plot(1:num,RMSEP,'linewidth',1.5);
%   text(1:num,RMSEP,num2str(Rpc'));
xlabel('Number of sampling runs');ylabel('RMSECV');

subplot(313);
plot(W');hold on;minW=min(min(W));maxW=max(max(W));plot(repmat(indexOPT,1,20),linspace(-maxW,maxW,20),'b*','linewidth',0.5);
d=abs(minW)*0.1;
axis([0 num -maxW-d maxW+d]);
xlabel('Number of sampling runs');ylabel('Regression coefficients path');

%%%%%%%%+++ END +++%%%%%%%%

