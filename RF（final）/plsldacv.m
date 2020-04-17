function CV=plsldacv(X,y,A,K,method,prior,OPT,order)
%+++ K-fold Cross-validation for PLS-LDA
%+++ Input:  X: m x n  (Sample matrix)
%            y: m x 1  (measured property)
%%
%            A: The maximal number of LVs for cross-validation
%            K: fold. when K = m, it is leave-one-out CV
%       method: pretreatment method. Contains: autoscaling, center etc.
%       prior: prior probability of positive class. Default to 0 for computing prior from data..say ldapinv.m for details.
%          OPT: =1 Print process.
%               =0 No print.
%               pareto,minmax,center or none.
%+++ Order: =1  sorted, default. For CV partition.
%           =0  random. 
%           =2  original order
%+++ Output: Structural data: CV
%+++ Hongdong Li, Oct. 16, 2008, lhdcsu@gmail.com
%+++ Revised in Jan.12, 2009.


if nargin<8,order=1;end
if nargin<7;OPT=1;end
if nargin<6;prior=0;end
if nargin<5;method='autoscaling';end
if nargin<4;K=10;end
if nargin<3;A=2;end



check=0; %+++ status variable:  1: Inf
if order==1
  [y,indexyy]=sort(y);
  X=X(indexyy,:);
elseif order==0
  indexyy=randperm(length(y));
  X=X(indexyy,:);
  y=y(indexyy);
end
[Mx,Nx]=size(X);
if K>Mx; K=Mx; end
A=min([size(X,1)-ceil(length(y)/K) size(X,2) A]);
yytest=[];YR=[];

groups = 1+rem(0:Mx-1,K);
yytest=[];YR=zeros(Mx,A);
for group=1:K
    testk = find(groups==group);  
    calk = find(groups~=group);
    Xcal=X(calk,:);ycal=y(calk);
    Xtest=X(testk,:);ytest=y(testk);
    
    %data pretreatment    
    [Xcal,para1,para2]=pretreat(Xcal,method);
      
    ycals=ycal;    
    Xtest=pretreat(Xtest,method,para1,para2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% SIM algorithm  %%%%%%%%%%%%%%   
    [B,wstar,T,P]=plsnipals(Xcal,ycals,A);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:A
        %%%+++ train model.        
        TT=T(:,1:j); 
        C=ldapinv(TT,ycal,prior);
%         coef=[wstar(:,1:j)*C(1:end-1);C(end)];        
        %+++ predict
%       y_est=Xtest*coef(1:end-1)+coef(end);
        Ttest=Xtest*wstar(:,1:j);
        y_est=Ttest*C(1:end-1)+C(end);
                
        YR(testk,j)=y_est;
    end
    if OPT==1;fprintf('The %dth fold for PLS-LDA finished.\n',group);end;
end



%+++ Original order
YR(indexyy,:)=YR;
y(indexyy)=y;
error=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:A
  error(i)=sum(sign(YR(:,i))~=y);    
end
error=error/Mx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[mincv,index]=min(error);
ROC=roccurve(YR(:,index),y,0); %+++ ROC area.
AUC=ROC.AUC;
k1=find(y==1);
k2=find(y==-1);
y_est=sign(YR(:,index));
se=1-sum(y_est(k1)~=sign(y(k1)))/length(k1);
sp=1-sum(y_est(k2)~=sign(y(k2)))/length(k2);

%+++ output  %%%%%%%%%%%%%%%%
CV.method=method;
CV.Ypred=YR;
CV.y=y;
CV.error=error;
CV.error_min=mincv;
CV.optLV=index;
CV.sensitivity=se;
CV.specificity=sp;
CV.AUC=AUC;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++ There is a song you like to sing.



