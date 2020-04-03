function F=carspls(X,y,A,K,method,num) 
%+++ CARS: Competitive Adaptive Reweighted Sampling method for variable selection.
%+++ X: The data matrix of size m x p
%+++ y: The reponse vector of size m x 1
%+++ A: the maximal principle to extract.
%+++ K: the group number for cross validation.
%+++ num: the  number of Monte Carlo Sampling runs.
%+++ method: pretreatment method.
%+++ Hongdong Li, Dec.15, 2008.
%+++ Advisor: Yizeng Liang, yizeng_liang@263.net
%+++ lhdcsu@gmail.com
%+++ Ref:  Hongdong Li, Yizeng Liang, Qingsong Xu, Dongsheng Cao, Key
%    wavelengths screening using competitive adaptive reweighted sampling 
%    method for multivariate calibration, Anal Chim Acta 2009, 648(1):77-84


tic;
%+++ Initial settings.
if nargin<6;num=50;end;
if nargin<5;method='center';end;
if nargin<4;K=5;end;
if nargin<3;A=2;end;

%+++ Initial settings.
[Mx,Nx]=size(X);
A=min([Mx Nx A]);
index=1:Nx;
ratio=0.9;
r0=1;
r1=2/Nx;
Vsel=1:Nx;
Q=floor(Mx*ratio);
W=zeros(Nx,num);
Ratio=zeros(1,num);

%+++ Parameter of exponentially decreasing function. 
b=log(r0/r1)/(num-1);  a=r0*exp(b);

%+++ Main Loop
for iter=1:num
     
     perm=randperm(Mx);   
     Xcal=X(perm(1:Q),:); ycal=y(perm(1:Q));   %+++ Monte-Carlo Sampling.
     
     PLS=pls(Xcal(:,Vsel),ycal,A,method);    %+++ PLS model
     w=zeros(Nx,1);coef=PLS.coef_origin(1:end-1,end);
     w(Vsel)=coef;W(:,iter)=w; 
     w=abs(w);                                  %+++ weights
     [ws,indexw]=sort(-w);                      %+++ sort weights
     
     ratio=a*exp(-b*(iter+1));                      %+++ Ratio of retained variables.
     Ratio(iter)=ratio;
     K=round(Nx*ratio);  
     
     
     w(indexw(K+1:end))=0;                      %+++ Eliminate some variables with small coefficients.  
     
     Vsel=weightsampling_in(w);                 %+++ Reweighted Sampling from the pool of retained variables.                 
     Vsel=unique(Vsel);              
     fprintf('The %dth variable sampling finished.\n',iter);    %+++ Screen output.
 end

%+++  Cross-Validation to choose an optimal subset;
RMSEP=zeros(1,num);
Q2_max=zeros(1,num);
Rpc=zeros(1,num);
for i=1:num
   vsel=find(W(:,i)~=0);
 
   CV=plscvfold(X(:,vsel),y,A,K,method,0);  
   RMSEP(i)=CV.RMSECV;
   Q2_max(i)=CV.Q2_max;   
   
   Rpc(i)=CV.optPC;
   fprintf('The %d/%dth subset finished.\n',i,num);
end
[Rmin,indexOPT]=min(RMSEP);
Q2_max=max(Q2_max);




%+++ save results;
time=toc;
%+++ output
F.W=W;
F.time=time;
F.cv=RMSEP;
F.Q2_max=Q2_max;
F.minRMSECV=Rmin;
F.iterOPT=indexOPT;
F.optPC=Rpc(indexOPT);
Ft.ratio=Ratio;
F.vsel=find(W(:,indexOPT)~=0)';



function sel=weightsampling_in(w)
%Bootstrap sampling
%2007.9.6,H.D. Li.

w=w/sum(w);
N1=length(w);
min_sec(1)=0; max_sec(1)=w(1);
for j=2:N1
   max_sec(j)=sum(w(1:j));
   min_sec(j)=sum(w(1:j-1));
end
 %figure(11);plot(max_sec,'r');hold on;plot(min_sec);
      
for i=1:N1
  bb=rand(1);
  ii=1;
  while (min_sec(ii)>=bb || bb>max_sec(ii)) && ii<N1;
    ii=ii+1;
  end
    sel(i)=ii;
end      % w is related to the bootstrap chance

%+++ subfunction:  booststrap sampling
% function sel=bootstrap_in(w);
% V=find(w>0);
% L=length(V);
% interval=linspace(0,1,L+1);
% for i=1:L;
%     rn=rand(1);
%     k=find(interval<rn);
%     sel(i)=V(k(end));    
% end

