function [x_snv] = snv(x)
% Standard Normal Variate                        （标准正态变量）
%
% [x_snv] = snv(x) 
%
% input:
% x (samples x variables) data to preprocess     （要预处理的x（样本x变量）数据）
%
% output:
% x_snv (samples x variables) preprocessed data  （样本x变量）预处理数据）

%


[m,n]=size(x);
rmean=mean(x,2);
dr=x-repmat(rmean,1,n);
x_snv=dr./repmat(sqrt(sum(dr.^2,2)/(n-1)),1,n);