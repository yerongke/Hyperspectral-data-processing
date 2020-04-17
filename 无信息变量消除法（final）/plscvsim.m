%#									
%# function [RMSECV,Yhat,E]=plscvsim(X,Y,XtX,S,standard,A,nxvals)	
%#												
%# AIM:       Performs CROSS-VALIDATION of PLS model with the		
%#	      aim to determine the optimal model complexity.		
%#								
%# PRINCIPLE: PLS cross-validation using the SIMPLS algorithm.		
%#									
%# REFERENCE: S. de Jong, Chemom. Intell. Lab. Syst., 18 (1993) 251-263.
%#									
%# INPUT:								
%#  X        predictor data matrix        (n x px)   centered		
%#  Y        predictand data matrix       (n x m)    centered		
%#  XtX      X'*X booster for px<<n       (px x px) 			
%#           otherwise XtX=[]						
%#  S        X'*Y interset covariances    (px x m)          		
%#  standard 1=yes/0=no autoscaling for X                		
%#  A        max # dimensions to consider (1 x 1)   <optional>     	
%#  nxvals   # cross-validation groups    (1 x 1)   <optional>		
%#									
%# OUTPUT:								
%#  RMSECV   Root Mean Square Error of CV  (m x A)			
%#            each row corresponds to a Y-variable			
%#            each column corresponds to a model using a-components	
%#  Yhat     Predicted Y 		  (n x A*m)			
%#            each row corresponds to the i-th object			
%#            each a-th block of m-columns to Yhat predicted 	
%#                 using a-components					
%#  E        Residual matrix 		  (n x A*m)			
%#            each row corresponds to the i-th object			
%#            each a-th block of m-columns to residuals E obtained 	
%#                 for all m-responses using a-components						
%#								
%# AUTHOR:								
%#	    Sijmen de Jong, 15/6/1997					
%# 	    Unilever Research Laboratorium, Vlaardingen, The Netherlands	
%#	    Copyright (c) 1997 for ChemoAC				
%#	    Dienst FABI, Vrije Universiteit Brussel			
%#	    Laarbeeklaan 103, 1090-Brussel Jette, Belgium		
%#									
%# VERSION: 1.1 (28/02/1998)					
%#									
%# TEST:     Vita Centner						
%#									
 
function [RMSECV,Yhat,E]=plscvsim(X,Y,XtX,S,standard,A,nxvals)

% disp('SIM-PLS cross-validation')
[n,px] = size(X);                       [n,m] = size(Y); 
if nargin<7, nxvals=n; end,             nxvals = min(max(2,nxvals),n);
if nargin<6, A=15; end,                 A = min(A, n-ceil(n/nxvals)-1);
rescale = ones(px,1);
PRESS = zeros(m,A+1);      
groups = 1+rem(0:n-1,nxvals);           %groups=ceil(nxvals*(1:n)/n);
A = min(A, n-ceil(n/nxvals)-1);
E = zeros(n,m*A);
%  clc
for group=1:nxvals
%  home
%  if nxvals==n,disp(['Leave one out object ',num2str(group),' of ',num2str(nxvals)]),end
%  if nxvals~=n,disp(['Leave out deletion group ',num2str(group),' of ',num2str(nxvals)]),end
  out = find(groups==group);            in = find(groups~=group);
  nin = length(in);                     nout = n-nin;
  mXin = -ones(1,nout)*X(out,:)/nin;    mYin = -ones(1,nout)*Y(out,:)/nin;
  Sin = S-X(out,:)'*Y(out,:)-mXin'*(mYin*nin);
  Xout = X(out,:)-mXin(ones(nout,1),:);
  Yout = Y(out,:)-mYin(ones(nout,1),:); 
  if standard
    rescale = sqrt((nin-1)./(n-1-ones(1,nout)*X(out,:).^2-mXin.^2*nin))';
    Sin = rescale(:,ones(m,1)).*Sin;    
  end
  PRESS(:,1) = PRESS(:,1)+(ones(1,nout)*(Yout.^2))';
  if ~isempty(XtX)
    C = XtX-X(out,:)'*X(out,:)-mXin'*(mXin*nin);
    S0 = Sin;
  end  
  StS = Sin'*Sin; 
  V = zeros(px,A); z = zeros(m,1);
  for a = 1:A
    StS = StS-z*z'; [Q,D] = eig(StS); [d,j] = max(diag(D)); r = Sin*Q(:,j(1));
    if isempty(XtX)     
      t = X(in,:)*(rescale.*r); t = t-sum(t)/nin; 
      v = (t'*X(in,:))'.*rescale;
    else
      v = rescale.*(C*(rescale.*r)); 
    end
    if isempty(XtX), f = (t'*Y(in,:))'/(t'*t); else f = (r'*S0)'/(r'*v); end
    Yout = Yout-(Xout*(r.*rescale))*f';
    E(out,(a-1)*m+(1:m))=Yout;
    PRESS(:,a+1) = PRESS(:,a+1)+(ones(1,nout)*(Yout.^2))';
    v = v-V(:,1:max(1,a-1))*(v'*V(:,1:max(1,a-1)))';
    v = v/sqrt(v'*v); V(:,a) = v;
    z = (v'*Sin)'; Sin = Sin-v*z'; 
  end
end
Yhat=kron(ones(1,A),Y-ones(n,1)*mean(Y))-E;
RMSECV=sqrt(PRESS(:,2:A+1)./n);
