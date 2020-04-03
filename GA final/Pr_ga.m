% PLSC 
% Response prediction
% sintax:
% [ypr]=pr_ga(x,wmat,pnorm,pmat,cmat,dvet,A,sy,my);
%   

function[ypr]=pr_ga(x,wmat,pnorm,pmat,cmat,dvet,A,sy,my);

[rx,cx]=size(x);

tmat2=[];

for a=1:A
 	t=x*wmat(:,a);
 	t=t*pnorm(a,1);
 	x=x-t*(pmat(:,a))';
 	tmat2(:,a)=t;
end;

ypr=[];
ypr1=((tmat2).*(ones(rx,1)*dvet(1:A)')).*(ones(rx,1)*cmat(1:A));
if A>1;	
	ypr1=(cumsum(ypr1'))';
end;
ypr=ypr1*sy+my;

