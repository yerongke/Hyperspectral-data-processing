function[pred]=predpls(x,y,xtest,ytest,compmax,aut);
if aut==2
  aut=3;
end
yor=y;
[rx,cx]=size(x); ry=size(y,1); cy=1;
if aut==0;
 df=0;
else;
 df=1;
end;

A=compmax;

% FITTING 

if aut==3;
  sx=std(x);
else;
  sx=ones(1,cx);
end;
if aut~=0;
  mx=mean(x);
  dofrx=1;
else;
  mx=zeros(1,cx);
  dofrx=0;
end;
if aut~=2; 
 x=(x-ones(rx,1)*mx)./(ones(rx,1)*sx);
else;
 mx=mean(mx);
 x=x-mx;
end;

if aut==3;
  sy=std(y);
else;
  sy=ones(1,cy);
end;
if aut~=0;
  my=mean(y);
  dofry=1;
else;
  my=zeros(1,cy);
  dofry=0;
end;
if aut~=2; 
   y=(y-ones(ry,1)*my)./(ones(ry,1)*sy);
else;
  my=mean(my);
  y=y-my;
end;

varinx=sum(x.^2);
variny=sum(y.^2);

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

% Goal: TIME RIDUCTION
% Results stored in the files bnew (constant terms) bc1 (Coeff. Var. 1-100)
% bc2 (101-200) bc3 (201-300) bc4 (301-400) bc5 (401-500) bc6 (501-600) bc7 (601-701)

cy=size(cmat,1);cx=size(wmat,1);

interc=zeros(1,cx);
interc=((interc-mx)./sx);
[bitc]=pre(interc,wmat,pnorm,pmat,cmat,dvet,A,sy,my);
bnew=bitc;

nmmat=['c01';'c02';'c03';'c04';'c05';'c06';'c07';'c08';'c09';'c10';'c11';'c12';'c13';'c14';'c15';'c16';'c17';'c18';'c19';'c20';'c21';'c22';'c23';'c24';'c25';'c26';'c27';'c28';'c29';'c30'];
nmcoe=['bc1';'bc2';'bc3';'bc4';'bc5';'bc6';'bc7';'bc8';'bc9';'b10';'b11';'b12';'b13';'b14';'b15';'b16';'b17';'b18';'b19';'b20';'b21';'b22';'b23';'b24';'b25';'b26';'b27';'b28';'b29';'b30'];
nlim=ceil(cx/100);
in=1;

while in<=nlim;
  if in==nlim;
   xres=cx-(in-1)*100;
   txt1a=[nmmat(in,:) '=[zeros(xres,(in-1)*100) eye(xres)];'];
   eval(txt1a);
  else;
   txt1b=[nmmat(in,:) '=[zeros(100,(in-1)*100) eye(100) zeros(100,cx-in*100)];'];
   eval(txt1b);
  end;
  for row=1:size(eval(nmmat(in,:)),1);
   txt2=[nmmat(in,:) '(row,:)=((' nmmat(in,:) '(row,:)-mx)./sx);'];
   eval(txt2);
  end;
  txt3=[nmcoe(in,:) '=pre(' nmmat(in,:) ',wmat,pnorm,pmat,cmat,dvet,A,sy,my);'];
  eval(txt3);
  txt4=['clear ' nmmat(in,:)];
  eval(txt4);
  for row=1:size(eval(nmcoe(in,:)),1);
   txt5=[nmcoe(in,:) '(row,:)=' nmcoe(in,:) '(row,:)-bitc;'];
   eval(txt5);
  end;
  bcy=eval(nmcoe(in,:));
  bnew=[bnew;bcy];
  clear bcy;
  txt7=['clear ' nmcoe(in,:)];
  eval(txt7);
  in=in+1;
end;

COE=bnew;clear bnew;
best1=compmax;

pred=zeros(size(xtest,1),1); 
pred(:,1)=[ones(size(xtest,1),1) xtest]*COE(:,best1);
pred=pred';

