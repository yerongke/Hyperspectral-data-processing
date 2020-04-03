function [nx] = normaliz(x) 
% Normalize matrix rows dividing by its norm     （规范化矩阵行除以其范数）
% 
% [nx] = normaliz(x)
%
% input:                                         （输入）
% x (samples x variables)   data to normalize    （要规范化的x（样本x变量）数据）
%
% output:                                        （输出）
% nx (samples x variables)  normalized data      （nx（样本x变量）规范化数据）


[m,n]=size(x);
nx=x;
nm=zeros(m,1);
for i = 1:m
nm(i)=norm(nx(i,:));
nx(i,:)=nx(i,:)/nm(i);
end
 %z=[1,2,3;3,4,5];
%[m,n]=size(z);
 %nx=z;
%nm=zeros(m,1);
%for i = 1:m
 %nm(i)=norm(nx(i,:));
 %nx(i,:)=nx(i,:)/nm(i);
%end