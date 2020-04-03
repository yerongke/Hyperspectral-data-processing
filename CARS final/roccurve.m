function F=roccurve(ypred,yreal,flag)
%+++ yreal: with elements 1 or -1;
%+++ ypred: real values.
%+++ flag: 1: plot
%          0: no plot.
%+++ June 11,2008.

if nargin<3;flag=1;end;

yreal=sign(yreal);
thitamin=min(ypred);thitamax=max(ypred);
K=128;
if K>size(yreal,1);K=size(yreal,1);end

thita=linspace(thitamin-0.000001,thitamax+0.000001,K);
Result=zeros(K,2);
for i=1:K
  r=sesp(ypred-thita(i),yreal);
  Result(i,:)=[r.specificity r.sensitivity];    
end
auc=abs(trapz(Result(:,1),Result(:,2)));
if flag==1
  plot(1-Result(:,1),Result(:,2));
  xlabel('1-specificity');ylabel('sensitivity');
end
r=sesp(ypred,yreal);
%+++ OUTPUT
F.value=Result;
F.sensitivity=r.sensitivity;
F.specificity=r.specificity;
F.accuracy=r.accuracy;
F.AUC=auc; % area under curve.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% subfunction   %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result=sesp(ypred_value,yreal_binary)
%+++ To calculate the sensitivity(Se) and the specificity(Sp) of 
%+++ a binary classification problem.
%+++ yreal_binary has to be 1 or -1.
%+++ Hongdong Li, Apr.29,2008.

ypred_value=sign(ypred_value);
yreal_binary=sign(yreal_binary);
p=0;n=0;o=0;u=0;LEN=length(yreal_binary);
for i=1:LEN
    if  yreal_binary(i)==1
       if ypred_value(i)==1;p=p+1;else;o=o+1;end
    elseif yreal_binary(i)~=1
       if ypred_value(i)~=1; n=n+1;else;u=u+1;end
    end   
end

%+++ output
result.sensitivity=p/(p+o);
result.specificity=n/(n+u);
result.accuracy=(p+n)/LEN;


