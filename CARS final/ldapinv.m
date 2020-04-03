function C=ldapinv(X,y,weight)
%+++weight: =0   Bayesian approximation.
%+++        =1   Fisher DA, classes weighted.
%+++ The last element in C is the bias term.
%+++Hongdong Li,Nov. 23.

y=sign(y);
A=length(y);
B=length(find(y==1));
C=A-B;
r1=A/B;r2=A/C;R=[];
kp=find(y==1);
kn=find(y==-1);
XX=[[X(kp,:) ones(B,1)];-[X(kn,:) ones(C,1)]];

if weight==0
    BB=ones(A,1);
elseif weight==1
    BB=[ones(B,1)*r1;ones(C,1)*r2];
end

C=inv(XX'*XX)*XX'*BB;

