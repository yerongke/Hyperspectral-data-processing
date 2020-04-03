function CV=plscvfold(X,y,A,K,method,PROCESS,order)
%+++ K-fold Cross-validation for PLS
%+++ Input:  X: m x n  (Sample matrix)
%            y: m x 1  (measured property)
%            A: The maximal number of latent variables for cross-validation
%            K: fold. when K=m, it is leave-one-out CV
%       method: pretreatment method. Contains: autoscaling,
%               pareto,minmax,center or none.
%      PROCESS: =1 : print process.
%               =0 : don't print process.
%+++ Order: =1  sorted, default. For CV partition.
%           =0  random. 
%+++ Output: Structural data: CV
%+++ Hongdong Li, Oct. 16, 2008.
%+++ Tutor: Prof. Yizeng Liang, yizeng_liang@263.net.
%+++ Contact: lhdcsu@gmail.com.

if nargin<7;order=1;end
if nargin<6;PROCESS=1;end;
if nargin<5;method='center';end;
if nargin<4;K=10;end;
if nargin<3;A=3;end;

check=0;

if order==1
  [y,indexyy]=sort(y);
  X=X(indexyy,:);
else
  indexyy=randperm(length(y));
  X=X(indexyy,:);
  y=y(indexyy);
end

[Mx,Nx]=size(X);
A=min([size(X) A]);
yytest=nan(Mx,1);
YR=nan(Mx,A);

groups = 1+rem(0:Mx-1,K);
for group=1:K
    testk = find(groups==group);  calk = find(groups~=group);
    Xcal=X(calk,:);ycal=y(calk);
    Xtest=X(testk,:);ytest=y(testk);
    
    %   data pretreatment
    [Xs,xpara1,xpara2]=pretreat(Xcal,method);
    [ys,ypara1,ypara2]=pretreat(ycal,method);   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [B,W,T,P,Q]=pls_nipals(Xs,ys,A,0);   % no pretreatment.
 
    yp=[];
    for j=1:A
        B=W(:,1:j)*Q(1:j);
        %+++ calculate the coefficient linking Xcal and ycal.
        C=ypara2*B./xpara2';
        coef=[C;ypara1-xpara1*C;];
        %+++ predict
        Xteste=[Xtest ones(size(Xtest,1),1)];
        ypred=Xteste*coef;
        yp=[yp ypred];
    end      
    
    YR(testk,:)=[yp];yytest(testk,:)=ytest;
    if PROCESS==1; fprintf('The %dth group finished.\n',group); end;
end

%+++ return the original order
yytest(indexyy)=yytest;
YR(indexyy,:)=YR;

if check==0

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  error=YR-repmat(yytest,1,A);
  PRESS=sum(error.^2);
  cv=sqrt(PRESS/Mx);
  [RMSEP,index]=min(cv);index=index(1);
  SST=sumsqr(yytest-mean(yytest));
  for i=1:A
    SSE=sumsqr(YR(:,i)-yytest);
    Q2(i)=1-SSE/SST;
  end
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %+++ output  %%%%%%%%%%%%%%%%
  CV.method=method;
  CV.check=0;
  CV.RMSECV=RMSEP;
  CV.Q2_all=Q2;
  CV.Q2_max=Q2(index);
  CV.Ypred=YR;
  CV.cv=cv;
  CV.optPC=index;
elseif check==1
  CV.method=method;
  CV.check=1;     
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%