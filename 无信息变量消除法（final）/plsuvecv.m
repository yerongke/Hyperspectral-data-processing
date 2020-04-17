%#										
%# function [t_values,RETAIN,RMSECVnew]=plsuvecv(X,Y,A,nxvals,pZ,cutoff);	
%#										
%# AIM:	        Full implementation of the 					
%#		Un-informative Variable Elimination (UVE)-PLS algorithm		
%#		including CROSS-VALIDATION.					
%#		The elimination of the original variables is performed for 	
%#		each (from 1 to A) number of components considered, giving A 	
%#		subsets of variables.						
%#		Finally, the predictive ability of models built using all 	
%#		subsets is evaluated over 1-A dimensions (yielding RMSEPnew).	
%#										
%# PRINCIPLE:   The UVE algorithm detects and eliminates from a PLS model  	
%#	        (including from 1 to A components) those variables that do 	
%#		not carry any relevant information to model Y. The criterion 	
%#		used to trace the un-informative variables is the reliability	
%#	        of the regression coefficients:					
%#	        c_j=mean(b_j)/std(b_j), obtained by jackknifing. 		
%#	        The cutoff level, below which c_j is considered to be 		
%#	        too small, indicating that the variable j should be removed, 		
%#	        is estimated using a matrix of random variables.		
%#	        The predictive power of PLS models built on the retained	
%#		variables only is evaluated over all 1-a dimensions 		
%#		(yielding RMSECVnew).						
%#										
%# REFERENCE:   V. Centner, D.L. Massart, O.E. de Noord, S. de Jong, 		
%#		B.M. Vandeginste, C. Sterna - Anal. Chem., 68 (1996) 3851-3858.	
%#										
%# INPUT:									
%#  X           predictor data matrix         (n x px)  original		
%#  Y           predictand data vector        (n x 1)   original	
%#  A           max # dimensions to consider  (1 x 1)				
%#  nxvals      # of CV groups         	      (1 x 1)  <optional> default: n	
%#  pZ          # of random variables         (1 x 1)  <optional> default: 200	
%#  cutoff      cutoff level considered       (1 x 1)  <optional> default: 0.99	
%#										
%# OUTPUT:									
%#  t_values    stability (reliability) of b: t=mean_b./std_b   (px x A)	
%#  RETAIN      retained variables: 1=yes/0=no	    	        (px x A)	
%#  RMSECVnew   RMSECV obtained on the RETAINED variables only  (A x A)		
%#                each row corresponds to a-components used in the elimination  
%#		 	step							
%#                each column corresponds to a-components applied in the final	
%#			evaluation of RMSECV using the retained variables only	
%#										
%# SUBROUTINES:	center.m, plssim.m, plscv.m					
%#										
%# AUTHOR:	Sijmen de Jong & Vita Centner					
%#		Copyright (c) 1997 for ChemoAC					
%#		Dienst FABI, Vrije Universiteit Brussel				
%#		Laarbeeklaan 103, 1090-Brussel Jette, Belgium			
%#																	
%# VERSION: 1.1 (28/02/1998)							
%#										
%# TEST:        Delphine Jouan-Rimbaud						
%#										

function [t_values,RETAIN,RMSECVnew]=plsuvecv(X,Y,A,nxvals,pZ,cutoff)

[n,px]=size(X);									% size of the data matrix
RMSECVnew=zeros(A,A);								% initialize RMSECVnew

if nargin < 6									% default values:
	cutoff=0.99;								%   cutoff: 0.99
	if nargin <5							
		pZ=200;								%   pZ: 200
		if nargin<4
			nxvals=n;						%   nxvals: n
		end
	end
end

randn('seed',sum(100*clock))
[Z]=center(randn(n,pZ),1);  							% (centered) matrix of random variables
mean_b=zeros(px,A); ssq_b=mean_b;						% variable initialisation
mean_bZ=zeros(pZ,A); ssq_bZ=mean_bZ;

disp(' ')
clc
% ### c-criterion to detect the un-informative variables for each a (ranging from 1 to A) ###
for out=1:n									% leave-one-out jackknifing over all (from 1 to A) dimensions
	home
        disp(['UVE-PLS with CV: Leave one out jackknifing: object ',num2str(out),' of ',num2str(n)])
	in=1:1:n; in(out)=[];							% training (in) and monitoring (out) set
	[Xince,mXince]=center(X(in,:),1);					% data centering
	[Yince,mYince]=center(Y(in,:),1);
	[b,c,P,T,U,R]=plssim(Xince,Yince,A,Xince'*Yince,[]);			% jackknifing over all 1-A dimensions
	bZ=center(Z(in,:),1)'*(pinv(Xince*Xince')*(T*triu(c'*ones(1,A))));
	ssq_b  = ssq_b   + ((R*triu(c'*ones(1,A))-mean_b).^2)*(1-1/out);	% updating of ssq_b, ssq_bZ, mean_b, mean_bZ
	mean_b = mean_b  + (R*triu(c'*ones(1,A))-mean_b)/out;
	ssq_bZ = ssq_bZ  + ((bZ-mean_bZ).^2)*(1-1/out);
	mean_bZ= mean_bZ + (bZ-mean_bZ)/out;
end
var_bZ = ssq_bZ/(n-1); var_b  = ssq_b /(n-1); 
t_values = sqrt(1/n)*[mean_b./sqrt(abs(var_b)); mean_bZ./sqrt(abs(var_bZ))];	% elimination criterion: mean(b)/std(b)

ppp = isnan(t_values);
[uno,dos] = find(ppp==1);
kl = length(uno);
for i = 1:kl
	t_values(uno(i),dos(i)) = 0;
end

disp(' ')
disp('Cross-validation on the retained variables ...')				% evaluation of the predictive power of the PLS models built on all (A) subsets of variables
disp(' ')
% ### Cross-validation on the variables retained for each number of components a ###
for a=1:A
        disp(['Leave one out CV using the variable subset obtained for ',num2str(a),' components '])
	disp(' ')
	crit = sort(abs(t_values(px+(1:pZ),a))); 
	crit = crit(round(cutoff*pZ));
	retain = abs(t_values(1:px,a))>crit;
	RETAIN(:,a) = retain;
	ret_var = find(retain==1);						% according to the t-values, eliminate the subset of variables for each a

	if ret_var ~= []
		[RMSECV] = plscv(X(:,ret_var),Y,0,a,nxvals);RMSECV=RMSECV	% PLS CV to evaluate the predictive ability of the PLS models built on the a-th subset of retained variables
		RMSECVnew(a,1:a) = RMSECV;					% place the results in the output matrix
	end

end
% ### Plot the UVE-PLS plot for each number of components considered ###	% UVE-PLS plot with the indication of the cutoff levels
for a = 1:A
	figure(a)
	crit = sort(abs(t_values(px+(1:pZ),a))); 
	crit = crit(round(cutoff*pZ));

	dif = max(t_values(:,a))-min(t_values(:,a));
	plot(1:px,t_values(1:px,a),'y-',...
	      px+(1:pZ),t_values(px+(1:pZ),a),'r-',...
	      [px+0.5 px+0.5],[min(t_values(:,a))-0.05*dif max(t_values(:,a))+0.05*dif],'b',...
	      [0 px+pZ],crit*[1 1],'b:',[0 px+pZ],-crit*[1 1],'b:')
	ylabel('t_value')

	axis([0 px+pZ min(t_values(:,a))-0.05*dif max(t_values(:,a))+0.05*dif])
	xlabel('real variables - index - random variables')
	title(['UVE plot when ',num2str(a),'-components are considered in the PLS model'])
end
disp('RMSECVnew obtained after the elimination of un-informative variables: ')
RMSECVnew = RMSECVnew
