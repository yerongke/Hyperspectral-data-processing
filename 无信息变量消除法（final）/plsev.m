%#									    
%# function [RMSEP,Yhat,E]=plsev(X,Y,Xt,Yt,standard,A);			    
%#									    
%# AIM:       Performs EXTERNAL-VALIDATION (EV) of PLS model with the	    
%#	      aim to determine the optimal model complexity.		    
%#	      Predicts Y of monitoring/test samples to quantify RMSEP.	    
%#									    
%# PRINCIPLE: PLS external-validation/evaluation of the predictive ability. 
%#									    
%# REFERENCE: H. Martens, T. Naes, Multivariate Calibration, 		    	
%#	      Wiley, Chichester, 1989.					    
%#									    
%# INPUT:								    
%#  X         predictor calibration matrix         (n x px)   original	    
%#  Y         predictand calibration matrix        (n x m)    original	    
%#  Xt        predictor monitoring/test matrix     (nt x px)  original	   
%#  Yt        predictand monitoring/test matrix    (nt x m)   original	    
%#  standard  1=yes/0=no autoscaling for X and Xt  (1 x 1)             	    
%#  A         max # dimensions to consider         (1 x 1)   <optional>     
%#	     	default: A=min([15 n-1 px])				    
%#									    
%# OUTPUT:								    
%#  RMSEP     Root Mean Square Error of Prediction  (m x A)		    
%#              each row corresponds to a Y-variable			    
%#              each column corresponds to a model using a-components	    
%#  Yhat      Predicted Y 		            (nt x A*m)		    
%#              each row corresponds to the i-th object			    
%#              each a-th block of m-columns to Yhat predicted 		    
%#                 using a-components					    
%#  E         Residual matrix 		            (nt x A*m)		    
%#              each row corresponds to the i-th object			    
%#              each a-th block of m-columns to residuals E obtained 	    
%#                 for all m-responses using a-components		    
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

function [RMSEP,Yhat,E]=plsev(X,Y,Xt,Yt,standard,A)
 
[n,px] = size(X);					% size of the data matrices
[n,m] = size(Y); 
if nargin<6, A=15; end					% default: A=15
A = min([A,n-1,px]);					% actual A=min([15 n-1,px])
if standard==0						% when autoscaling is not required:
	[Xce,mX,Xtce]=center(X,1,Xt);			% data centering
	[Yce,mY,Ytce]=center(Y,1,Yt);
	Yhat=[];Yhat_a=[];E=[];E_a=[];
	for a=1:A					% for each number of dimensions considered:
		[B]=plssim(Xce,Yce,a,Xce'*Yce,[]);	% model development
		Yhat_a=Xtce*B;				% prediction, Yhat_a is centered
		E_a=Yhat_a-Ytce; 			% residuals E obtained using a-components
		E=[E,E_a];				% E over all dimensions
		RMSEP(:,a)=(sqrt(mean(E_a.^2)))'; 	% Root Mean Square Error of Prediction
		E_a=[];
		[Yhat_a]=invcente(Yhat_a,mY);		% inverse centering of the predicted Yhat_a
		Yhat=[Yhat,Yhat_a];			% Yhat over all dimensions (in the original scale) 
		Yhat_a=[];
	end
end
if standard==1						% when autoscaling is required:
	[Xauto,mX,sX,Xtauto]=scale(X,1,Xt);		% X and Xt autoscaling
	[Yce,mY,Ytce]=center(Y,1,Yt);			% Y and Yt centering
	Yhat=[];Yhat_a=[];E=[];E_a=[];
	for a=1:A,
		[B]=plssim(Xauto,Yce,a,Xauto'*Yce,[]);	% model development
		Yhat_a=Xtauto*B;			% prediction, Yhat_a is centered)
		E_a=Yhat_a-Ytce; 			% residuals E obtained using a-components
		E=[E,E_a];				% E over all dimensions
		RMSEP(:,a)=(sqrt(mean(E_a.^2)))'; 	% Root Mean Square Error of Prediction
		E_a=[];
		[Yhat_a]=invcente(Yhat_a,mY);		% inverse centering for the predicted Yhat_a
		Yhat=[Yhat,Yhat_a];			% Yhat over all dimensions (in the original scale)
		Yhat_a=[];
	end
end
RMSEP=RMSEP
