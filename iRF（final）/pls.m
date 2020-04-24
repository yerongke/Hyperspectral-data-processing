function PLS=pls(X,y,A,method)
%+++  PLS=pls(x0,y0,A,method);
%+++  Input:
%     X,y: sample data and y-value to predict
%     A: number of PLS components
%     method: pretreat method for X, either "center" or "autoscaling". y is
%     always centered in our libPLS package.
%+++  Ouput : is a structural array which are explained at the end of this code.
%+++  Hongdong Li, June 1,2008.
%+++  Tutor:Yizeng Liang, yizeng_liang@263.net.
%+++  Contact: lhdcsu@gmail.com.

if nargin<4;method='center';end
if nargin<3;A=2;end;


[Mx,Nx]=size(X);

%+++ check effectiveness of A.
A=min([Mx Nx A]);


%+++ data pretreatment
[Xs,xpara1,xpara2]=pretreat(X,method);
[ys,ypara1,ypara2]=pretreat(y,'center');

%+++ Use the pretreated data to build a PLS model
[B,Wstar,T,P,Q,W,R2X,R2Y]=plsnipals(Xs,ys,A); % notice that here, B is the regression coefficients linking Xs and ys.

%+++ perform target projection;
[tpt,tpw,tpp,SR]=tp(Xs,B);     

%+++ calculate VIP *********************
VIP=vip(Xs,ys,T,W,Q);

%+++ get regression coefficients that link X and y (original data) ************
coef=zeros(Nx+1,A);
for j=1:A
    Bj=Wstar(:,1:j)*Q(1:j);
    C=ypara2*Bj./xpara2';
    coef(:,j)=[C;ypara1-xpara1*C;];
end

%+++ ********************************************
x_expand=[X ones(Mx,1)];
ypred=x_expand*coef(:,end);
error=ypred-y;
%********************************************
SST=sum((y-mean(y)).^2);
SSR=sum((ypred-mean(y)).^2);
SSE=sum((y-ypred).^2);
R2=1-SSE/SST;


%+++ Output************************************** 
PLS.method=method;
PLS.X_pretreat=Xs;
PLS.y_pretreat=ys;
PLS.regcoef_pretreat=B;
PLS.regcoef_original_all=coef;
PLS.regcoef_original=coef(:,end);
PLS.X_scores=T;
PLS.X_loadings=P;
PLS.VIP=VIP;
PLS.W=W;
PLS.Wstar=Wstar;
PLS.y_fit=ypred;
PLS.fitError=error;
PLS.tpscores=tpt;
PLS.tploadings=tpp;
PLS.SR=SR;
PLS.SST=SST;
PLS.SSR=SSR;
PLS.SSE=SSE;
PLS.RMSEF=sqrt(SSE/Mx);
PLS.R2=R2;
%+++ END ++++++++++++++++++++++++++++++++++++
%+++ There is a song you like to sing in your memory.
