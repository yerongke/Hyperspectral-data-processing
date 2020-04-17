%#									     
%# function [Ynew_hat]=plspred(X,Y,Xnew,standard,a);			     
%#									     
%# AIM:       Predicts Yhat of new samples (Ynew is unknown) using PLS model 
%#	      with a-components, where a was determined by CROSS/EXTERNAL    
%#	      validation (using the m-file: plscv.m or plsev.m)		     
%#									     
%# REFERENCE: H. Martens, T. Naes, Multivariate Calibration, 		     
%#	      Wiley, Chichester, 1989.					     
%#									     
%# INPUT:								     
%#  X         predictor calibration matrix           (n x px)     original   
%#  Y         predictand calibration matrix          (n x m)      original   
%#  Xnew      predictors matrix of new sample(s)     (nnew x px)  original   
%#  standard  1=yes/0=no autoscaling for X and Xnew  (1 x 1)                 
%#  a         # dimensions to consider               (1 x 1) 		     
%#									     				
%# OUTPUT:								     
%#  Ynew_hat  Y of the new samples predicted using the PLS model including   
%#	      a-components			     (nnew x m)		     
%#              each row corresponds to the i-th new object		     
%#              each column to the j-th predictand (for multiple Y)	     
%#									     
%# SUBROUTINES: center.m, invcente.m, scale.m, plssim.m			     
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

function [Ynew_hat]=plspred(X,Y,Xnew,standard,a)
 
[n,px]=size(X);   					% size of the data matrices                    
[n,m]=size(Y); 
if standard==0						% if autoscaling is not required:
	[Xce,mX,Xnew_ce]=center(X,1,Xnew);		% data centering
	[Yce,mY]=center(Y,1);
	[B]=plssim(Xce,Yce,a,Xce'*Yce,[]);	        % model development
	Ynew_hat=Xnew_ce*B;				% prediction, Ynew_hat is centered
	[Ynew_hat]=invcente(Ynew_hat,mY);		% inverse centering of Ynew_hat (the result is in the original scale)
end
if standard==1						% if autoscaling is required
	[Xauto,mX,sX,Xnew_auto]=scale(X,1,Xnew);	% X and Xt autoscaling
	[Yce,mY]=center(Y,1);				% Y and Yt centering
	[B]=plssim(Xauto,Yce,a,Xauto'*Yce,[]);		% model development
	Ynew_hat=Xnew_auto*B;				% prediction, Ynew_hat is centered
	[Ynew_hat]=invcente(Ynew_hat,mY);		% inverse centering of Ynew_hat (the result is in the original scale)
end
