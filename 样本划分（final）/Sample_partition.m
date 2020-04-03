load('RAW.mat');
X=RAW(:,1:254);
Y=RAW(:,255);
k = k_pca(X,8);
 

%[m,dminmax] =spxy(X,Y,300);