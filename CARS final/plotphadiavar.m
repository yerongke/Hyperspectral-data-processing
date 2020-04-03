function [error0,error1]=plotphadiavar(F,index,n0,n1)
%+++ plot the predictive accuracy distribution for a given variable
%+++ lhdcsu@gmail.com
%+++ Sep. 12, 2009

if nargin<4;n1=15;end
if nargin<3;n0=15;end;
if nargin<2;index=1;end

c=[1 1 1];  %+++ white color;
nVAR=length(F.DMEAN);
model=zeros(0,nVAR);
model(F.model{index})=1;
PredError=F.PredError;
error1=PredError(find(model==1));
error0=PredError(find(model==0));
[n11,xout1] = hist(error1,n1);
[n00,xout0] = hist(error0,n0);
axiss=[ min([n00 n11])   max([n00 n11])];


c0=[1 1 1];
c1=[0.5 0.5 0.5];

if 1==1
  [H,xbin1,ybin1]=histfitnew(error1,n1,[0.5 0.5 0.5],'k',0.4);
  hold on;
  [H,xbin0,ybin0]=histfitnew(error0,n0,'w','k',0.4);
  box on;
   
end


%+++ Axis limitation
minx=min([xbin0 xbin1]);
maxx=max([xbin0 xbin1]);
dx=(maxx-minx)/30;
miny=min([ybin0 ybin1]);
maxy=max([ybin0 ybin1]);
dy=(maxy-miny)/20;
axis([minx-dx maxx+dx miny-0.01*dy maxy+dy]);
box on;









