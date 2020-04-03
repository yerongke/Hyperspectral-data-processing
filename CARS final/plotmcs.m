function plotmcs(F,threshMEAN,threshSTD,ID)
%+++ To plot for the result F obtained from 
%+++ the outlier detection method: mcs.m
%+++ Coded by Hongdong Li, lhdcsu@gmail.com


if nargin<4;ID=[1:length(F.MEAN)]';end;
if nargin<3;threshSTD=0;end;
if nargin<2;threshMEAN=0;end;

MEAN=F.MEAN;
STD=F.STD;
N=length(STD);
h=plot(MEAN,STD,'*');
set(h(1),'marker','none');
hold on;
text(MEAN,STD,num2str(ID));
xlabel('MEAN');ylabel('STD');  
plot(repmat(threshMEAN,1,3),linspace(min(F.STD),max(F.STD),3),'b-');
plot(linspace(min(F.MEAN),max(F.MEAN),3),repmat(threshSTD,1,3),'b-');
