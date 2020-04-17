%#												
%# function [mean_b,std_b,t_values,var_retain,RMSECVnew,Yhat,E]=plsuve(X,Y,a,nxvals,pZ,cutoff);			
%#												
%# AIM:	       Simple implementation of the 							
%#             Un-informative Variable Elimination (UVE)-PLS algorithm.				
%#	       Variable elimination is carried out only for single a.				
%#												
%# PRINCIPLE:  The algorithm detects and eliminates from a PLS model  				
%#	       (including a-components) those variables that do not carry			
%#	       any relevant information to model Y. The criterion used to 			
%#	       distinguish the informative and un-informative variables is			
%#	       the reliability (stability) of the regression coefficients:			
%#	       c_j=mean(b_j)/std(b_j), obtained by jackknifing. 				
%#	       The cutoff level, below which c_j is considered to be 				
%#	       too small, indicating that the variable j should be removed, 			
%#	       is estimated using a matrix of random variables attached 			
%#	       artificially to the experimental data.						
%#	       The predictive power of the model built on the retained 			
%#	       variables only is evaluated over all 1-a dimensions 				
%#	       (yielding RMSECVnew).								
%#												
%# REFERENCE:  V. Centner, D.L. Massart, O.E. de Noord, S. de Jong, B.M. Vandeginste, C. Sterna	
%#	       Anal. Chem., 68 (1996) 3851-3858.						
%#												
%# INPUT:											
%#  X          predictor data matrix                    (n x px)   original			
%#  Y          predictand data vector                   (n x 1)    original			
%#  a          # components to determine the criterion  (1 x 1)					
%#  nxvals     # jackknifing and CV groups           	(1 x 1)   <optional> default: n		
%#  pZ         # of random variables   	            	(1 x 1)   <optional> default: 200	
%#  cutoff     cutoff level considered            	(1 x 1)   <optional> default: 0.99	
%#												
%# OUTPUT:											
%#  mean_b     estimated mean PLS b-coefficients                  (1 x px)			
%#  std_b      estimated std of the PLS b-coefficients            (1 x px)			
%#  t_values   stability (reliability) of b: t=mean_b./std_b      (1 x px)			
%#  var_retain indexes of the retained variables    	          (1 x p_retain)		
%#  RMSECVnew  RMSECV obtained on the RETAINED variables only     (1 x a)			
%#               each row corresponds to a-components used in the final CV			
%#		 (the model complexity applied for the elimination is a)			
%#  Yhat       Predicted Y 		                          (n x a)			
%#              each row corresponds to the i-th object						
%#              each a-th column to Yhat obtained using a-components				
%#  E          Residual matrix 		                          (n x a)			
%#              each row corresponds to the i-th object						
%#              each a-th column to residuals E obtained with a-components			
%#												
%# AUTHOR:     Vita Centner									
%#	       Copyright (c) 1997 for ChemoAC							
%#	       Dienst FABI, Vrije Universiteit Brussel						
%#	       Laarbeeklaan 103, 1090-Brussel Jette, Belgium					
%#												
%# VERSION: 1.1 (28/02/1998)								
%#												
%# TEST:        Delphine Jouan-Rimbaud								
%#												

function [mean_b,std_b,t_values,var_retain,RMSECVnew,Yhat,E]=plsuve(X,Y,a,nxvals,pZ,cutoff)

switch nargin
    case 5
        cutoff=0.99;
    case 4
        cutoff=0.99; pZ=200;
    case 3
        cutoff=0.99; pZ=200; nxvals=size(X,1);
end

% ### Data preparation ###
[n,px]=size(X);								% size of the X-matrix
randn('seed',sum(100*clock));
rand('seed',sum(100*clock));
[ii,j]=sort(randn(n,1));						% j is a vector of randomly permutated integers from 1 to n
X=[X(j,:),1E-10*randn(n,pZ)];						% permutation of the X rows, addition of random variables*E-10 to X
Y=Y(j,:);								% permutation of Y
clc
disp(' ')

% ### Leave-group-out jackknifing on PLS b-coeff. including a-components ###
B=[];
for i=1:nxvals					
	home, disp(['UVE-PLS: Leave group out jackknifing: group ',num2str(i),' of ',num2str(nxvals)])
	out=i:nxvals:n; in=(1:1:n);in(out)=[];				% data splitting: in (training), out (monitoring)
	[Xince]=center(X(in,:),1); [Yince]=center(Y(in,:),1);		% data centering
	[b]=plssim(Xince,Yince,a,Xince'*Yince,[]);			% PLS b-coeff. obtained using the training (in) data, a-components considered
	B=[B;b']; b=[];							% B-matrix: includes b-coeff. for all training groups
end

% ### Determination of the UVE-PLS criterion: mean(b)./std(b) ###
mean_b=mean(B); std_b=std(B); t_values=mean_b./std_b;

% ### Elimination of the uninformative variables ###
disp(' ')
disp('Cross-validation on the subset of the retained variables ... ')
crit=sort(abs(t_values(1,px+(1:pZ)))); crit=crit(round(cutoff*pZ));	% determination of the cut-off t-value (denoted as crit)
retain=abs(t_values(1,1:px))>crit;					% 0=un-informative variables, 1=informative variables
var_retain=find(retain==1);						% indexes of the retained variables (take those that have retain==1)

% ### RMSECV evaluation using only the retained variables ###
[RMSECVnew,Yhat,E]=plscv(X(:,var_retain),Y,0,a,nxvals);			% PLSCV using the retained variables only
Yhat(j,:)=Yhat; E(j,:)=E;						% inverse permutation of Yhat and E

% ### Visualization of results: UVE-PLS plot ###
dif=max(t_values(1,1:px))-min(t_values(1,1:px));			% temporary variable
plot(1:px,t_values(1,1:px),'m-o',...					% UVE-PLS plot with the  cut-off levels
       px+(1:pZ),t_values(1,px+(1:pZ)),'c-o',...
       [px+0.5 px+0.5],[min(t_values(1,1:px))-0.05*dif max(t_values(1,1:px))+0.05*dif],'r:',...
	      [0 px+pZ],crit*[1 1],'r:',[0 px+pZ],-crit*[1 1],'r:')
ylabel('t_value')
axis([0 px+pZ min(t_values(1,1:px))-0.05*dif max(t_values(1,1:px))+0.05*dif])
xlabel('real variables - index - random variables')
title(['UVE plot when ',num2str(a),'-components are considered in the PLS model'])

% ### Visualization of the numerical results: RMSECVnew ###
disp(' ')
disp('RMSECVnew obtained after the elimination of the un-informative variables: ')
RMSECVnew=RMSECVnew
