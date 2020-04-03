function LDA=plslda(X,y,A,method,weight)
%+++ programmed according to NIPALS algorithm by Hongdong Li,Oct. 2006.
%+++ model: x=t*p'   y=t*r'=u*q'
%+++ y0 has to satisfy:  +1: positive class and -1:negative class;
%+++ A: number of latent variables
%+++ method:    'autoscaling', default
%        or 'center' 
%        or 'pareto';
%+++ weight: whether classes need to be weighted 
%            0: no weight, default
%            1: assigning the same weight to each class
%+++ Advisor: Yizeng Liang, yizeng_liang@263.net
%+++ H.D. Li, Feb. 8, 2009, lhdcsu@gmail.com

if nargin<5;weight=0;end
if nargin<4;method='autoscaling';end;
if nargin<3;A=2;end;
if nargin<2;warn('Wrong input parameters!');end
A=min([size(X) A]);

%%%%%%%%%% PLS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Xs,para1,para2]=pretreat(X,method);
ys=y;  
[B,Wstar,T,P,Q,W,R2X,R2Y]=plsnipals(Xs,ys,A);
VIP=vip(Xs,ys,T,W,Q);
%%%%%%%%%% LDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tpt,tpw,tpp,SR]=tp(Xs,B);             %+++ target projection and selectivity ratio
C=ldapinv(T,y,weight);                      %+++ Discriminant analysis
yfit=T*C(1:end-1)+C(end);
ROC=roccurve(yfit,y,0);
B0=[Wstar(:,1:A)*C(1:end-1);C(end)];

%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%
  LDA.method=method;
  LDA.scale_para=[para1;para2];
  LDA.yreal=y;
  LDA.regcoef_pretreat=B;
  LDA.VIP=VIP;
  LDA.Wstar=Wstar;
  LDA.W=W;
  LDA.Xscores=T;
  LDA.Xloadings=P;
  LDA.R2X=R2X;
  LDA.R2Y=R2Y;
  LDA.tpScores=tpt;
  LDA.tpLoadings=tpp;
  LDA.SR=SR;
  LDA.LDA='*********  LDA ***********';
  LDA.regcoef_lda_lv=C;
  LDA.regcoef_lda_origin=B0;
  LDA.yfit=yfit;
  LDA.error=1-ROC.accuracy;
  LDA.sensitivity=ROC.sensitivity;
  LDA.specificity=ROC.specificity;
  LDA.AUC=ROC.AUC;
%+++ There is a song you like to sing.