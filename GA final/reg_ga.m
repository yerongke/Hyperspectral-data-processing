% PLSC 
% Computation of Regression Parameters
% sintax:
% [wmat,umat,pmat,cmat,dvet,pnorm]=reg_ga(x,y,A);;

function[wmat,umat,pmat,cmat,dvet,pnorm]=reg_ga(x,y,A);

[rx,cx]=size(x);
[ry,cy]=size(y);
a=0;

while a<A;
 	a=a+1;
 	u1=y(:,1);
 	w1=ones(cx,1);
 	n=0; 
 	scat=0; 
 	wesold=10^40;
 	while scat==0;
  		n=n+1;
  		% Computing weights (marginal regression coeff. of predictors on u1)
  		w=(x'*u1)/(u1'*u1);
  		w=w/norm(w);
  		wes=sum(abs(w-w1));
  		w1=w;
  		% Computing scores on latent variables (t)
  		t=x*w;
  		% Computing regression coeff. of response variable y and latent variable t
  		% (with only one response variable c is a scalar)
  		c=(t'*y)/(t'*t);
  		c=c';
  		cnor=c/norm(c);
  		u1=y*cnor;
  		if (wes<cx*0.00000001)|(n>20&(abs(wes-wesold))<0.000001);
  			scat=1;
  		end;
  		wesold=wes;
 	end;
 	% Computing predictor regression coeff. on latent variable t
 	p=(t'*x)/(t'*t);
 	p=p';
 	pnor=p/norm(p);
 	tnew=t*norm(p);
 	wnew=w*norm(p);
 	% Computing regression coeff. of lat. variable Y on lat. variable X
 	d=(tnew'*u1)/(tnew'*tnew);
 	% computing residuals
 	x=x-t*p';
 	y=y-tnew*d*cnor'; 
 	% Storing calculated parameters w, t, p, c, d 
 	wmat(:,a)=w;
 	tmat(:,a)=tnew;
 	pmat(:,a)=pnor;
 	cmat(:,a)=cnor;
 	dvet(a,1)=d;
 	umat(:,a)=u1;
 	pnorm(a,1)=norm(p);
end;
