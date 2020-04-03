% PLSC for MATLAB
% Computing of error terms
% sintax:
% [best,exp_var_cv]=err_ga(y,ypred,A,sy,variny);
%

function[best,exp_var_cv]=err(y,ypred,A,sy,variny);

[ry,cy]=size(y);

ym=[];vyv=[];syv=[];

ym=y*ones(1,A);
syv=sy*ones(1,A);
vyv=variny*ones(1,A);

if ry>1;
  	ww=sum((ypred-ym).^2);
else;
  	ww=(ypred-ym).^2;
end;

% Vector ww contains the absolute error sum of square terms
% each element of this vector is referred to one Y predicted with a latent variables

varsp=100-(((100*ww)./(syv.^2))./vyv);

ress=ones(1,A)*10^37;
sovs=zeros(1,A);

k=1:A;
k1=find(varsp==100);
k(k1)=[];
ress(k)=100./(100-varsp(k));
sovs=ress;


sww1t=0; sw3t=0; asw3t=0;
[val,sww1t]=max(varsp);
sw3t=sww1t*ress(sww1t);
asw3t=ress(sww1t);

best=fix(sw3t/asw3t+0.5);  
 
exp_var_cv=varsp(best);
