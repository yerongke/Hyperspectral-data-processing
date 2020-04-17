%#									   
%# function [RMSECV,Yhat,E]=plscv(X,Y,standard,A,nxvals);		   
%#									   
%# AIM:       Performs CROSS-VALIDATION (CV) of PLS model with the	   
%#	      aim to determine the optimal model complexity.		   
%#									   
%# PRINCIPLE: PLS cross-validation using the SIMPLS or WIMPLS algorithm,   
%#	      respectively for tall or wide X-data. The optimal approach   
%#	      is selected automatically.	    		           
%#									   
%# REFERENCE: H. Martens, T. Naes, Multivariate Calibration, Wiley, 	   
%#		Chichester, 1989.					   
%#            S. de Jong, Chemom. Intell. Lab. Syst., 18 (1993) 251-263.   
%#									   
%# INPUT:								   
%#  X         predictor data matrix        (n x px)   original		   
%#  Y         predictand data matrix       (n x m)    original		   
%#  standard  1=yes/0=no autoscaling for X                		   
%#  A         max # dimensions to consider (1 x 1)   <optional>     	   
%#		default: A=min([15 n-n/nxvals-1])			   
%#  nxvals    # cross-validation groups    (1 x 1)   <optional>		   
%# 		default: nxvals=n (leave-one-out)			   
%#									   
%# OUTPUT:								   
%#  RMSECV    Root Mean Square Error of CV  (m x A)			   
%#              each row corresponds to a Y-variable			   
%#              each column corresponds to a model using a-components	   
%#  Yhat      Predicted Y 		  (n x A*m)			   
%#              each row corresponds to i-th object			   
%#              each a-th block of m-columns to Yhat predicted 		   
%#                 using a-components					   
%#  E         Residual matrix 		  (n x A*m)			   
%#              each row corresponds to i-th object			  
%#              each a-th block of m-columns to residuals E obtained 	   
%#                 for all m-responses using a-components		   
%#									   
%# SUBROUTINES: center.m, invcente.m, plscvsim.m, plscvwim.m		   
%#									   
%# AUTHOR:    Vita Centner						   
%#	      Copyright (c) 1997 for ChemoAC				  
%#	      Dienst FABI, Vrije Universiteit Brussel			   
%#	      Laarbeeklaan 103, 1090-Brussel Jette, Belgium		   
%#									   
%# VERSION: 1.1 (28/02/1998)						   
%#									   
%# TEST:      Delphine Jouan-Rimbaud	 				   
%#									   

function [RMSECV,Yhat,E]=plscv(X,Y,standard,A,nxvals)
 
[n,px] = size(X);                       [n,m] = size(Y); 					% size of the data
perm=randperm(n);
X=X(perm,:);				Y=Y(perm,:);
if nargin<5, nxvals=n; end,             nxvals = min(max(2,nxvals),n);				% default: nxvals=n (leave-one-out)
if nargin<4, A=15; end,                 A = min(A, n-ceil(n/nxvals)-1);				% default: A=min([15 n-n/nxvals-1])
[Xce,mX]=center(X,1);										% data centering (plscvsim.m and plscvwim.m require centered X and Y)
[Yce,mY]=center(Y,1);
if standard==0											% if autoscaling is not required, different (SIM or WIM) plscv algorithms are applied according to the size of X
	if px>n | px==n, [RMSECV,Yhatce,E]=plscvwim(Xce*Xce',Yce,A,nxvals); end			% when px>n or ==n (most usual case: wide X-data), plscvWIM.m is used
	if px<n & px>0.1*n, [RMSECV,Yhatce,E]=plscvsim(Xce,Yce,[],Xce'*Yce,0,A,nxvals); end	% when px<n, but not 10-times less (tall X-data, but not extremely), plscvSIM.m is used without the X'*X booster
	if px<0.1*n, [RMSECV,Yhatce,E]=plscvsim(Xce,Yce,Xce'*Xce,Xce'*Yce,0,A,nxvals); end	% when px<<n (more than 10-times, i.e. when X-data are very tall), plscvSIM.m is used with the X'*X booster
end
if standard==1											% if autoscaling is required, only plscvSIM is applied
	if px>0.1*n, [RMSECV,Yhatce,E]=plscvsim(Xce,Yce,[],Xce'*Yce,1,A,nxvals); end		% when X is wide or not extremely tall (px>0.1*n), the X'*X booster is not used
	if px<0.1*n, [RMSECV,Yhatce,E]=plscvsim(Xce,Yce,Xce'*Xce,Xce'*Yce,1,A,nxvals); end	% when X is very tall (px<0.1*n), the booster is applied
end
mYA=[]; for a=1:A, mYA=[mYA,mY]; end								% preparation of the matrix mYA to perform inverse centering of Yhatce (for multiple Y)
[Yhat]=invcente(Yhatce,mYA);									% inverse centering of the predicted (multiple) Y
Yhat(perm,:)=Yhat;
E(perm,:)=E;

