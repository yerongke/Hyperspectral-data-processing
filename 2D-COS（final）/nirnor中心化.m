%#  function [ndata]=nirnor(data);
%#
%#  AIM:   正规化（normalization），用于光谱数据预处理
%#
%#  INPUT:  data        m×n的矩阵，m个光谱，n个变量
%#
%#  OUTPUT: ndata       中心化后的光谱矩阵
%#          me          均值
%#
%#  AUTHOR: 王毅 
%#  EMAIL:  wang727yi@hotmail.com
%#  VERSION:1.0 (16/03/2009)
%#	  

function [ndata]=nirnor(data);

[m,n]=size(data); 

mindata=zeros(1,n); % 生成一个1*n大小的全0矩阵数组
maxdata=zeros(1,n);

for j=1:n
    mindata(j)=min(data(:,j));
    maxdata(j)=max(data(:,j));
    ndata(:,j)=(data(:,j)-mindata(j))/(maxdata(j)-mindata(j));
end

