%#											
%#  function [optfilter,W1,W2,modelcoef,RMSECV,RMSEP]= rcepls(xc,yc,filter,xt,yt)	
%#											
%#  AIM: 	Relevant Component Extraction for PLS.					
%#											
%#  PRINCIPLE:  This algorithm works as described in the article			
%#		"Application of wavelet transform to extract the relevant		
%#		component from spectral data for multivariate calibration",		
%#		Analytical Chemistry, in press.						
%#											
%#		First, the Discrete Wavelet Transform (DWT) of the mean			
%#		spectrum is computed, and the best filter is chosen as			
%#		that yielding the smallest Minimum Descriptor Length (MDL)		
%#		for spectrum reconstruction. In this program, only the			
%#		filters from the Daubechies family (including the Haar			
%#		wavelet) are proposed.							
%#		Then, all individual spectra are decomposed with this			
%#		optimal filter, and a modified UVE-PLS method is applied,		
%#		where the wavelet coefficients associated to noise (irrelevant		
%#		for spectrum reconstruction) play the role of the random		
%#		variables, while the wavelet coefficients considered			
%#		relevant for spectrum reconstruction play the role of the		
%#		real variables in UVE-PLS. Therefore, the selected variables		
%#		are not real original variables, but wavelet coefficients.		
%#		One can easily go from the wavelength domain to the wavelet		
%#		domain, and vice-versa.							
%#											
%#  INPUT:										
%#	xc :	(row x col) calibration matrix, with row objects and			
%#		col variables (col = 2^J, J integer!)					
%#		The variables must be regularly sampled					
%#	yc :	(row x 1) the dependent variable					
%#	filter:	Number of filter to apply: even number between 0 and 20			
%#		 0 : if you do not know the filter number, in order to optimise it	
%#		 2 : Haar wavelet							
%#		 n (n = 4 - 20) : Filter number n from the Daubechies family of filters	
%#	xt :	(rowt x col) OPTIONAL							
%#		Test matrix of independent variables					
%#	yt :	(row x 1) OPTIONAL							
%#		Test dependent variable							
%#											
%#  OUTPUT:										
%#	optfilter: Optimal filter number						
%#	W1 :	Index of wavelet coefficients relevant for spectral			
%#		reconstruction (Found by the MDL criterion)				
%#	W2 :	Index of the wavelet coefficients irrelevant for			
%#		spectral reconstruction (noise coefficients).				
%#	modelcoef: Subset of wavelet coefficients from W1, relevant			
%#		   for the model (final selected cofficients)				
%#	RMSECV:	Cross-validated root mean square error of prediction,			
%#		with the subset of selected wavelet coefficients.			
%#	RMSEP:	OPTIONAL								
%#		root mean square error of prediction for the test set			
%#											
%#  SUBROUTINES:									
%#	saito.m	Finds the wavelet coefficients relevant for signal			
%#		reconstruction (W1), and those associated to noise (W2).		
%#	wtdrce.m Presentation of a spectrum in the wavelet domain			
%#	plscv.m	PLS with cross-validation						
%#	plspred.m Prediction of y with PLS							
%#															
%#  AUTHORS: 	Delphine Jouan-Rimbaud - Beata Walczak - Luisa Pasti			
%#	    	Copyright(c) 1997 for ChemoAC						
%#          	FABI, Vrije Universiteit Brussel					
%#          	Laarbeeklaan 103 1090 Jette						
%#											
%# VERSION: 1.1	(28/02/1998)								
%#											   										
%#  TEST:   	Vita Centner								
%#											

function [optfilter,W1,W2,modelcoef,RMSECV,RMSEP]=rcepls(xc,yc,filter,xt,yt)

clc

[row,col]=size(xc);

if rem(col,log2(col))~=floor(rem(col,log2(col)))
   disp(' ')
   error('	The number of variables should be an integer power of two!')
end

mxc=mean(xc);		% mean spectrum of the calibration xc

if exist('xt')==1
   rowt=size(xt,1);
   mxt=mean(xt);	% mean spectrum of test xt
end


% Decomposition of spectra in the wavelet domain

if filter==0	% optimise filter
   optim_MDL=[];
   for i=1:10
home
disp(' ')
disp([' Testing filter number ',int2str(2*i)]);

% Decomposition of the mean spectrum mxc with filter 2*i:
	[coef]=wtdrce(i,mxc);	

% Saito's method to determine the optimal number of
% wavelet coefficients for spectral reconstruction
	[W1,W2,MDL]=saito(coef);
	optim_MDL=[optim_MDL;2*i,length(W1),MDL];
	clear W1 W2 MDL
   end
   disp(' ')
   disp(optim_MDL);
   [minMDL,iMDL]=min(optim_MDL(:,3));	% the optimal filter is that
   optfilter=iMDL;			% yielding smallest MDL.
clear minMDL iMDL

% decomposition of mxc with the optimal filter
   [coef]=wtdrce(optfilter,mxc);
   [W1,W2,MDL]=saito(coef);
   disp(' ')
   disp(['## The optimal filter is filter number ',int2str(2*optfilter)])
   disp(['## The corresponding MDL value is ',num2str(MDL)])

else		% filter is known, just decompose mxc, and apply Saito to separate W1 from W2

   optfilter=filter/2; clear filter
% Decomposition of the mean spectrum mxc with filter optfilter:
   [coef]=wtdrce(optfilter,mxc);
   [W1,W2,MDL]=saito(coef);
   disp(' ');
   disp(['## The utilized filter is filter number ',int2str(2*optfilter)])
   disp(['## The corresponding MDL value is ',num2str(MDL)])
end

lw1=length(W1);	% Number of wavelet coefficients relevant for spectral reconstruction;
lw2=length(W2); % Number of wavelet coefficients associated to noise

disp(' ')

% All spectra of xc (and, possibly, xt) can be decomposed with filter number optfilter;
% The obtained "spectra" (in the wavelet domain) are placed in a matrix wc (and, possibly, wt).
for i=1:row
   wc(i,:)=wtdrce(optfilter,xc(i,:));
end

if exist('xt')==1,
   for i=1:rowt
	wt(i,:)=wtdrce(optfilter,xt(i,:));
   end
end


%*** PLS modelling ***
disp(' ')
model_A=input('## Do you know the dimensionality of the original PLS model? (y/n) ','s');
if model_A=='Y', model_A='y'; end
if model_A=='y',
   Aopt=input('## Complexity of the original PLS model? ');
else
   disp(' ')
   disp('## The original model complexity will then be estimated with cross-validation');
   Amax=input('## Maximal number of factors to compute for cross-validation [10] ? ');
   if isempty(Amax), Amax=10; end
   rmsecv=plscv(wc,yc,0,Amax,row);	% PLS with cross-validation
   plot(1:Amax,rmsecv,'-')		% Show plot RMSECV vs Nb of factors
   xlabel('Number of factors')
   ylabel('RMSECV')
   figure(gcf),pause,close
   Aopt=input('## Dimensionality of the optimal model ? ');
   rmsecvopt=rmsecv(Aopt);
   disp(' ');
   disp(['## The optimal model includes ',int2str(Aopt),' factors'])
   disp('');
   disp(['## The corresponding cross-validation error is ',num2str(rmsecvopt)]);
end

if exist('xt')==1
   [ytp]=plspred(xc,yc,xt,0,Aopt);	% Prediction of test set with the optimal PLS model.
   rmsepopt=rms(yt,ytp);
   disp(' ');
   disp(['## The prediction error of the ',int2str(Aopt),'-factors PLS model is ',num2str(rmsepopt)]);
end


% Leave-one-out cross-validation to calculate the reliability of the
% b-coefficients corresponding to the optimal PLS model
C=[];
for i=1:row
   wcmodel=wc;wcmodel(i,:)=[];
   ycmodel=yc;ycmodel(i)=[];
   wcmodel=wcmodel-ones(row-1,1)*mean(wcmodel);
   ycmodel=ycmodel-mean(ycmodel);
   b=plssim(wcmodel,ycmodel,Aopt);
   C=[C;b'];
end

ccoef=mean(C)./std(C);	% reliability coefficient
ccoef=ccoef([W1,W2]);	% The ccoef are sorted such that coef. relevant
			% for spectrum reconstruction are placed first.
	

plot(1:col,ccoef,'y',[lw1,lw1],[min(ccoef),max(ccoef)],'r-')
ylabel('c-ratio')
text(floor(lw1/2),0.8*max(ccoef),'Relevant range');
text(floor((lw1+lw2/2)),0.8*max(ccoef),'Irrelevant range');
pause,close

ccoef1=ccoef(1:lw1);
ccoef2=ccoef(lw1+1:lw1+lw2);


thold=(1/0.6745)*median(abs(ccoef2));	% Threshold value

disp(' ')
disp(' ')
disp('## In the final thresholding, the constant can vary between 1 and 3')
step=input('## Choose the step of variation [0.5] ');
if isempty(step), step=0.5; end

results=[];
A=input('## Maximal number of factors in the PLS models with selected wavelet coefficients? ');
for i=1:step:3,
   th=thold*i;
   plot([1:col],[ccoef1,ccoef2],'y',[1;col],[1;1]*th,'g-',[1;col],[1;1]*(-th),'g-',[lw1 lw1],[min(ccoef) max(ccoef)],'r-')
   title(['Constant = ',num2str(i)]);
   figure(gcf),pause,close
   selected=find(abs(ccoef1)>th);	% coefficients relevant for model
   modelcoef=W1(selected);		% coefficients relevant for model,
					% with original indexes.	 
   if length(selected)~=0
% PLS with leave-one-out cross-validation on the selected wavelet coefficients
	rmsecv=plscv(wc(:,modelcoef),yc,0,A,row);
	figure(2)
	plot(1:A,rmsecv,'-')
	xlabel('Number of factors')
	ylabel('RMSECV')
	title(['Constant = ',num2str(i)]);
	figure(gcf),pause,close
	[rmsecvmin,Amin]=min(rmsecv);
	Aopt=input(['## Optimal number of factors? [',int2str(Amin),'] ']);
	if isempty(Aopt), Aopt=Amin; end
	rmsecvopt=rmsecv(Aopt);
% Prediction of the test set
	if exist('wt')==1,
	   [ytp]=plspred(wc(:,modelcoef),yc,wt(:,modelcoef),0,Aopt);
	   rmsepopt=rms(yt,ytp);
	else
	   rmsepopt=[];
	end

	results=[results;i,Aopt,length(modelcoef),rmsecvopt,rmsepopt];

clear rmsecv rmsecvopt Aopt rmsepopt Amin rmsecvmin
   end
end
disp(' ')
disp(' ')
disp(results)

[minrmsecv,ind]=min(results(:,4));	% The optimal model is that yielding
					% the smallest prediction error in
					% cross-validation.

RMSECV=results(ind,4);
disp(' ')
disp('## Final Results : ');
disp(' ');
disp(['	The optimal model retains ',int2str(results(ind,3)),' wavelet coefficients']);
disp('')
disp(['	The corresponding PLS model includes ',int2str(results(ind,2)),' factors']);
disp('')
disp(['	The cross-validated prediction error is : RMSECV = ',num2str(RMSECV)])
disp('')
if exist('xt')==1
   RMSEP=results(ind,5);
   disp(['	The prediction error is : RMSEP = ',num2str(RMSEP)])
end
cte=results(ind,1);
th=thold*cte;
selected=find(abs(ccoef1)>th);
modelcoef=W1(selected);
l=length(modelcoef);

p=1;
while p~=0
   plotres=menu('Which plot would you like to see?',...
	     'None',...
	     'Predicted versus Observed Y',...
	     'Spectra reconstructed with coefficients relevant for spectrum reconstruction (W1)',...
	     'Spectra reconstructed with noise coefficients (W2)',...
	     'Spectra reconstructed with coefficents relevant for modelling',...
	     'Spectra reconstructed with coefficients irrelevant for modelling');

   if plotres==1, p=0; end

   if plotres==2,
	if exist('xt')==0,
	   disp(' ');
	   disp('NO TEST SET IS AVAILABLE!!!');
	else
	   figure(p)
	   [ytp]=plspred(wc(:,modelcoef),yc,wt(:,modelcoef),0,results(ind,2));
	   r=corrcoef(yt,ytp); r=r(1,2);
	   plot(yt,ytp,'o',yt,yt,'-')
	   xlabel('Y observed')
	   ylabel('Y predicted')
	   title(['RMSEP = ',num2str(RMSEP),' ; r = ', num2str(r)])
	   figure(gcf),pause
	   p=p+1;
	end
   end

   if plotres>2, qmf=wave(optfilter); end

   if plotres==3
	Wc1=zeros(row,col);
	Wc1(:,W1)=wc(:,W1);
	for i=1:row, rxc1(i,:)=wti(qmf,Wc1(i,:),1); end

	figure(p)
	subplot(211)
	plot(xc')
	xlabel('Wavelengths')
	ylabel('Calibration spectra');
	subplot(212)
	plot(rxc1')
	xlabel('Wavelengths')
	ylabel('Reconstructed spectra')
	title('Coefficients used relevant for spectrum reconstruction')
	figure(gcf),pause
	p=p+1;
   end

   if plotres==4
	Wc2=zeros(row,col);
	Wc2(:,W2)=wc(:,W2);
	for i=1:row, rxc2(i,:)=wti(qmf,Wc2(i,:),1); end

	figure(p)
	subplot(211)
	plot(xc')
	xlabel('Wavelengths')
	ylabel('Calibration spectra');
	subplot(212)
	plot(rxc2')
	xlabel('Wavelengths')
	ylabel('Reconstructed noise')
	figure(gcf),pause
	p=p+1;
   end

   if plotres==5
	Wcrel=zeros(row,col);
	Wcrel(:,modelcoef)=wc(:,modelcoef);
	for i=1:row, rxcrel(i,:)=wti(qmf,Wcrel(i,:),1); end

	figure(p)
	subplot(211)
	plot(xc')
	xlabel('Wavelengths')
	ylabel('Calibration spectra');
	subplot(212)
	plot(rxcrel')
	xlabel('Wavelengths')
	ylabel('Reconstructed spectra')
	title('Coefficients used relevant for model')
	figure(gcf),pause
	p=p+1;
   end

   if plotres==6
	Wcirrel=Wc1;
	Wcirrel(:,modelcoef)=zeros(row,l);
	for i=1:row, rxcirrel(i,:)=wti(qmf,Wcirrel(i,:),1); end

	figure(p)
	subplot(211)
	plot(xc')
	xlabel('Wavelengths')
	ylabel('Calibration spectra');
	subplot(212)
	plot(rxcirrel')
	xlabel('Wavelengths')
	ylabel('Reconstructed spectra')
	figure(gcf),pause
	p=p+1;
   end
end

optfilter=optfilter*2;
