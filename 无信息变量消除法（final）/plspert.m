%#											
%# function [complexity,level] = plspert(xcal,ycal,A,valset)				
%#											
%# AIM:		Performs INTERNAL VALIDATION of PLS model with the aim to determine	
%#		optimal model complexity. (Alternative to CROSS-VALIDATION)	
%#		Warning : this method cannot be applied to first or second derivative	
%#		spectral data.								
%#											
%# PRINCIPLE:	PLS models with different complexities are tested on a			
%#		subset of calibration samples (validation set) on which instrumental 	
%#   		perturbations have been simulated. The complexity of the model 		
%#		with the best performance on perturbed data is retained. The level of 	
%#		simulated perturbation is adapted according to the percentage of 
%#		variance in Y explained by the first PLS factor.			
%#											
%# REFERENCE:	F.Despagne, D.L.Massart, O.E.de Noord: "Optimization of PLS calibration	
%#		models by simulation of instrumental perturbations"			
%#		Analytical Chemistry, 69 (1997) 3391-3399				
%# 											
%# INPUT:	xcal : (nc*p) matrix of spectra, calibration set.			
%#		ycal : (nc*1) vector of responses, calibration set.	 		
%#		A : maximum number of latent variables for the PLS model.		
%#		valset : (nv*1) indices of samples from the calibration set to use in	
%#		         the validation set (optional). If not provided, a default 	
%#			 validation set will be selected with the Kennard-Stone		
%#			 algorithm.							
%#											
%# OUTPUT:	complexity : suggested number of PLS factors				
%#		level : perturbation level applied					
%#											
%# WARNING:   	In some cases, the number of factors extracted from X in the subroutine	
%#		PLSSIM will be smaller than LV because there is no covariance left of 	
%#		Y with X. In this case only the number of factors extracted (<A)	
%#		can be tested with simulated perturbations.				
%# 											
%# SUBROUTINES: kenston.m : Kennard-Stone design					
%#		center.m : centering							
%#		plssim.m : calculates PLS model 					
%#		simuldev.m : simulates instrumental perturbations			
%#		invcente.m : restores the mean of centered data 			
%#											
%# AUTHOR:	Frederic Despagne							
%#		Copyright(c) 1996 for ChemoAC						
%#		Dienst FABI, Vrije Universiteit Brussel					
%#		Laarbeeklaan 103, 1090 Jette						
%#											
%# VERSION: 1.1 (28/02/1998)								
%#											
%# TEST:	Delphine Jouan-Rimbaud							
%#											

function [complexity,level] = plspert(xcal,ycal,A,valset)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESSING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close
[nc,p] = size(xcal);
calset = [1:nc];
disp(' ')
if nargin == 3
	disp('Selecting validation samples')
	nt = ceil(0.66*nc);
	trainset = kenston(xcal,nt,1,0,ycal);	% Selection of default training samples
	calset(trainset) =[];
	valset = calset;			% Indices of default validation samples
else
	calset(valset) = [];
	trainset = calset;			% Indices of samples in the training set
end
[nv]=size(valset,1);
xtrain = xcal(trainset,:);			% Training set, spectra
ytrain = ycal(trainset,:);			% Training set, responses
xval = xcal(valset,:);				% Validation set, spectra 
yval = ycal(valset,:);				% Validation set, responses
[mxtrain,mx,mxval] = center(xtrain,1,xval);	% Column-centering of spectra
[mytrain,my] = center(ytrain,1,yval);		% Column-centering of responses
rmsev=zeros(A,1);				% Initialization of RMSEP values


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MODELING WITH PLS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('Calculating PLS model on calibration samples and simulating perturbations');
catch = mxtrain'*mytrain;			% Catcher matrix, for PLS modeling
[b,c,p,t,u,r,r2x,r2y] = plssim(mxtrain,mytrain,A,catch,[]);	% Builds PLS model
A = size(c,2);

%%%%%%%%%%%%%%%%%%%%%%%% ADJUSTMENT OF PERTURBATION LEVELS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concind = r2y(1);	% Percentage variance in Y explained by first latent variable
if concind <= 20
	level = 5;	% Lowest perturbation level
elseif concind <= 60
	level = 15;	% Second perturbation level
elseif concind <= 80
	level = 60;	% Third perturbation level
else 
	level = 80;	% Highest perturbation level
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIMULATION OF PERTURBATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% From each original spectrum, 11 new spectra are created

xval = simuldev(xval,level);	% Simulates perturbations on validation spectra
yvalmax = [yval;yval;yval;yval;yval;yval;yval;yval;yval;yval;yval]; % Augmented vector of responses, validation set


%%%%%%%%%%%%%%%%%% PREDICTIONS ON THE VALIDATION SET WITH THE PLS MODEL %%%%%%%%%%%%%%%%%%

disp(' ')
disp('Predicting responses of validation samples')
ypred = zeros(nv,1);
for i = 1:A
	ypred = mxval*(r(:,1:i)*c(:,1:i)');		% Estimated response
	pred(:,i) = invcente(ypred,my);			% Returns estimated responses to original scale
	rmsep_val(i,:) = rms(yval,pred(:,i));		% Calculates RMSEP for validation set
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% DETERMINATION OF OPTIMAL COMPLEXITY %%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ');
plot(rmsep_val)					% Plots RMSEP values for the validation set
xlabel('Latent variables')
ylabel('RMSEP')
title('RMSEP on validation set')
%prindex = input('Do you want to print this graph ? (y/n) ','s');
%if prindex=='Y', prindex=='y'; end
%if prindex == 'y'
%	print
%end
%close
[indvalmin,complexity] = min(rmsep_val); 	% Finds minimum RMSEP
disp(' ');
suggest = sprintf('The suggested complexity is %2.0f factors',complexity); % Optimal complexity
disp(suggest)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

