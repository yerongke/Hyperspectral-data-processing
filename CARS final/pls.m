function PLS=pls(X,y,A,method);
%+++  PLS=pls(x0,y0,A,method);
%+++  programmed based on the 'pls_nipals.m' in the package of new chemo_AC
%+++  developted by Massart's Group.
%+++  The returned PLS is a struct array.
%+++  Hongdong Li, June 1,2008.
%+++ Tutor:Yizeng Liang, yizeng_liang@263.net.
%+++ Contact: lhdcsu@gmail.com.

if nargin<4;method='center';end
if nargin<3;A=2;end;

[Mx,Nx]=size(X);
A=min([Mx Nx A]);
check=0; %+++ check the data. 1: data is probamatic 
%data pretreatment
[Xs,xpara1,xpara2]=pretreat(X,method);
[ys,ypara1,ypara2]=pretreat(y,method);

if check==0
  %++++ call the subroutine: pls_nipals.m of new chemo_AC.
  [B,W,T,P,Q,R2X,R2Y,Xr,Yr]=pls_nipals(Xs,ys,A,0);
  [tpt,tpw,tpp,SR]=tp(Xs,B);             %+++ target projection;
  %get regression coefficient linking x0 and y0****************
  coef=zeros(Nx+1,A);
  for j=1:A
    Bj=W(:,1:j)*Q(1:j);
    C=ypara2*Bj./xpara2';
    coef(:,j)=[C;ypara1-xpara1*C;];
  end

 %+++ ********************************************
  x_expand=[X ones(Mx,1)];
  ypred=x_expand*coef(:,end);
  error=ypred-y;
  %********************************************
  SST=sum((y-mean(y)).^2);SSR=sum((ypred-mean(y)).^2);
  SSE=sum((y-ypred).^2);R2=1-SSE/SST;
  %********************************************
  %+++  vip=vipp(xstd,ystd,tt,ww);
  %Output************************************** 
  PLS.method=method;
  PLS.check=0;
  PLS.coef_origin=coef;
  PLS.coef_standardized=B;
  PLS.X_scores=T;
%   PLS.VIP=VIP;
  PLS.Wstar=W;
  PLS.y_est=ypred;
  PLS.residue=error;
  PLS.tpscores=tpt;
  PLS.tploadings=tpp;
  PLS.SR=SR;
  PLS.Xr=Xr;
  PLS.yr=Yr;
  PLS.SST=SST;
  PLS.SSR=SSR;
  PLS.SSE=SSE;
  PLS.RMSEF=sqrt(SSE/Mx);
  PLS.R2=R2;
  % PLS.F_value=(Mx-A-1)*SST/Nx/SSE;
  %+++ END ++++++++++++++++++++++++++++++++++++
elseif check==1
  PLS.method=method;
  PLS.check=1; 
end

%+++ There is a song you like to sing in your memory.
