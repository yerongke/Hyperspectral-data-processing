function [x_msc]=msc(x,xref)
% Multiplicative Scatter Correction  （多元散射校正）
%
% [x_msc]=msc(x,xref)  xref外部参照
%
% input 
% x (samples x variables)      spectra to correct                                （x（样本x变量）光谱校正）
% xref (1 x variables)         reference spectra (in general mean(x) is used)    （外部参照（1 x变量）参考光谱（通常使用平均值（x））
% Output
% x_msc (samples x variables)  corrected spectra                                 （x_msc（样本x变量）校正光谱）

[m n]=size(x);
rs=xref;cw=ones(1,n);
mz=[];mz=[mz ones(1,n)'];mz=[mz rs'];
[mm,nm]=size(mz);
wmz=mz.*(cw'*ones(1,nm));
wz=x.*(ones(m,1)*cw);
z=wmz'*wmz;
[u,s,v]=svd(z);sd=diag(s)'; 
cn=10^12;
ms=sd(1)/sqrt(cn);
cs=max(sd,ms ); 
cz=u*(diag(cs))*v';  
zi=inv(cz);
b=zi*wmz'*wz';B=b';
x_msc=x; 
p=B(:,1);x_msc=x_msc-(p*ones(1,mm));
p=B(:,2);x_msc=x_msc./(p*ones(mm,1)');