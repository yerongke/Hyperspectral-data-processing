%#									
%# function [RMSECV,Ypred,E]=plscvwim(D,Y,A,nxvals)			
%#									
%# AIM:       Performs CROSS-VALIDATION of PLS model with the 		
%#	      aim to determine the optimal model complexity.		
%#									
%# PRINCIPLE: PLS cross-validation using the SIMPLS algorithm		
%#	      modified for wide X-data. The algorithm uses the small	
%#	      matrix D=X*X' (n x n) instead of the original wide X.	
%#									
%# REFERENCE: S. de Jong, Chemom. Intell. Lab. Syst., 18 (1993) 251-263.
%#									
%# INPUT:								
%#  D        X*X'                         (n x n)			
%#  X        predictor data matrix        (n x px)   centered		
%#  Y        predictand data matrix       (n x m)    centered		
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
%#	   Sijmen de Jong						
%# 	   Unilever Research Laboratorium, Vlaardingen, The Netherlands	
%#	   Copyright (c) 1997 for ChemoAC				
%#	   Dienst FABI, Vrije Universiteit Brussel			
%#	   Laarbeeklaan 103, 1090-Brussel Jette, Belgium		
%#									
%# VERSION: 1.1 (28/02/1998)						
%#									
%# TEST:     Vita Centner						
%#									

function [RMSECV,Yhat,E]=plscvwim(D,Y,A,nxvals)

% disp('WIM-PLS cross-validation')
[n,m] = size(Y); 
if nargin<4, nxvals=n; end,     nxvals = min(max(2,nxvals),n);
if nargin<3, A=15; end,         A = min(A, n-ceil(n/nxvals)-1);
PRESS = zeros(m,A+1);           C = zeros(m,A); 
groups = 1+rem(0:n-1,nxvals);   %groups = ceil(nxvals*(1:n)/n);

E = zeros(n,m*A);
%  clc
for group=1:nxvals
%  home
%  if nxvals==n,disp(['Leave one out object ',num2str(group),' of ',num2str(nxvals)]),end
%  if nxvals~=n,disp(['Leave out deletion group ',num2str(group),' of ',num2str(nxvals)]),end
  out = find(groups==group);    in = find(groups~=group);
  nout = length(out);           nin = n-nout;
  Din = D(in,in);
  h = sum(Din)';                h = (h-mean(h)/2)/nin;
  Din = Din-(h(:,ones(1,nin))'+h(:,ones(1,nin)));
  mYin = -ones(1,nout)*Y(out,:)/nin;
  Yin = Y(in,:)-mYin(ones(nin,1),:);
  PRESS(:,1) = PRESS(:,1)+(ones(1,nout)*((Y(out,:)-mYin(ones(nout,1),:)).^2))';
  T = zeros(nin,A);  H = T;  U = T;  PROJ = T; 
  temp = zeros(1,A);
  F = Yin;
  for a = 1:A
    [Q,LAMBDA] = eig(F'*Din*F);         [l,j] = max(diag(LAMBDA)); 
    u = F*Q(:,j(1));                    U(:,a) = u;
    t = Din*u; t = t/sqrt(t'*t);        T(:,a) = t;  
    h = Din*t; H(:,a) = h; 
    PROJ(:,1:a) = T(:,1:a)*inv(T(:,1:a)'*H(:,1:a));
    F  = Yin - PROJ(:,1:a)*(H(:,1:a)'*Yin);
  end
  C = (T'*Yin)';
  T = D(out,in)*U*inv(triu(H'*U));
  for j=1:m
    U = Y(out,j)*ones(1,A)-T*triu(C(j,:)'*ones(1,A));
    U = U+ones(nout,1)*(ones(1,nout)*U/nin);
    PRESS(j,2:A+1) = PRESS(j,2:A+1)+ones(1,nout)*(U.^2);
    E(out,j+(0:A-1)*m)=U;
  end
end

Yhat=kron(ones(1,A),Y)-E;
RMSECV=sqrt(PRESS(:,2:A+1)./n);
