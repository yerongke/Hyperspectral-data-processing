function C=ldapinv(X,y,prior)
%+++ prior: custermized prior probability of for a sample to be positive class, which is a real in (0,1). 1-prior is the prob for a sample to belong to negative class. Default is 0, indicating prior is not custermized by users but auto-computed from the data. When prior=0.5, both classes are equally weighted.
%+++ The last element in C is the bias term.
%+++Hongdong Li,Nov. 23.
%+++ Ref: Richard O. Duda, Pattern Classificatin, Chapter 5.


if nargin<3;prior=0;end

if prior <0 || prior >=1
	warning('prior must be in (0,1)')
end


y=sign(y);
A=length(y);
B=length(find(y==1));
C=A-B;

if prior >0         % custermized prior
	r1=prior/B;
	r2=(1-prior)/C;
elseif prior == 0  % derive prior from sample sizes of each class.
	r1=B/B;
	r2=C/C;
end


R=[];
kp=find(y==1);
kn=find(y==-1);
XX=[[X(kp,:) ones(B,1)];-[X(kn,:) ones(C,1)]];

BB=[ones(B,1)*r1;ones(C,1)*r2];    % notes:  for each class, nsample*weight = prior.
C=inv(XX'*XX)*XX'*BB;


