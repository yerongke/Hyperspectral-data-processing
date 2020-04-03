function [t,w,p,sr]=tp(X,b)
%+++ target projection for PLS proposed by Olav Kvalheim et al.
%+++ regression vector from PLS
%+++ Advisor: Yizeng Liang, yizeng_liang@263.net.
%+++ H.D. Li, Feb. 12, 2010, lhdcsu@gmail.com.


w=b/norm(b);
t=X*w;
p=X'*t/(t'*t);

Xtp=t*p';
Xr=X-Xtp;

%+++ Compute selectivity ratio
for i=1:size(X,2)
  vart(i)=sumsqr(X(:,i));
  vartp(i)=sumsqr(Xtp(:,i));
  varr(i)=sumsqr(Xr(:,i));
end
sr=vartp./varr; % sr.
%+++ end


