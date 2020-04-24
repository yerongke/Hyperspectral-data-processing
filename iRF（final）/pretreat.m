function [X,para1,para2]=pretreat(X,method,para1,para2)
%+++   data pretreatment数据预处理
%+++ HD Li, Central South University


if nargin==2
  [Mx,Nx]=size(X);
   if strcmp(method,'autoscaling')
    para1=mean(X);para2=std(X);
   elseif strcmp(method,'center')
    para1=mean(X);para2=ones(1,Nx);
   elseif strcmp(method,'unilength')
    para1=mean(X);
    for j=1:size(X,2);
    para2(1,j)=norm(X(:,j)-para1(j));
    end
   elseif strcmp(method,'minmax')
    para1=min(X);maxv=max(X);
    para2=maxv-para1;  
   elseif strcmp(method,'pareto');
    para1=mean(X);para2=sqrt(std(X));
   else
    display('Wrong data pretreat method!');
   end
   
   for i=1:Nx
     X(:,i)=(X(:,i)-para1(i))/para2(i);
   end
   
elseif nargin==4
   [Mx,Nx]=size(X);
   for i=1:Nx     
     X(:,i)=(X(:,i)-para1(i))/para2(i);
   end
end



