function [Xcal,ycal,Xtest,ytest]=traintestselect(X,y,ratio,OPT)
%+++ This function is used to select a training and corresponding test
%    from the whole dataset.
%+++ X: sample matrix of size m x p
%+++ y: class label vector of size m x 1, must of element 1 or -1
%+++ ratio: The ratio of the number of train samples to the whole data
%+++ OPT:  0 regression
%          1 classification
%+++ Advisor: Yi-Zeng Liang, yizeng_liang@263.net
%+++ H.D. Li, Apr. 21, 2010, lhdcsu@gmail.com


if OPT==0
  n=size(X,1);
  nperm=randperm(n);  
  Q=floor(n*ratio);
  Xcal=X(nperm(1:Q),:);
  ycal=y(nperm(1:Q));
  Xtest=X(nperm((Q+1):end),:);
  ytest=y(nperm((Q+1):end));
  

elseif OPT==1
  %+++ ID number of two classes of samples
id1=find(y==1);
id2=find(y~=1);
n1=length(id1);
n2=length(id2);
X1=X(id1,:);X2=X(id2,:);
y1=y(id1,:);y2=y(id2,:);

%+++ Selection strategy
rank1=randperm(n1);
rank2=randperm(n2);


%+++ Number of calibration samples for each class
nc1=round(n1*ratio);
nc2=round(n2*ratio);

calk1=rank1(1:nc1);
calk2=rank2(1:nc2);
testk1=rank1((1+nc1):n1);
testk2=rank2((1+nc2):n2);
%+++ Output
Xcal=[X1(calk1,:);X2(calk2,:)];
ycal=[y1(calk1,:);y2(calk2,:)];

Xtest=[X1(testk1,:);X2(testk2,:)];
ytest=[y1(testk1,:);y2(testk2,:)];

end


