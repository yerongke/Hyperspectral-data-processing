%#											
%# function [smdata] = smooth(data,window)						
%#											
%# AIM:		Performs average smoothing on spectral data.				
%#											
%# PRINCIPLE:	The function smoothes the original data by calculating a moving		
%#		average on a finite-size spectral window. On both ends of the spectrum, 
%#		points outside the spectral window are determined by second-order	
%#		polynomial extrapolation before calculating the average.		
%#										
%#		Reference :								
%#		D.L.Massart, B.G.M.Vandeginste, S.N.Deming, Y.Michotte, L.Kaufman	
%#		"Chemometrics, a textbook"						
%#		Elsevier, Amsterdam, The Netherlands (1988)				
%#											
%# INPUT:	data (m x n): Original data set (each row is a spectrum)		
%#		window: Spectral window size, must be an odd number (default: 3)	
%#											
%# OUTPUT:	smdata (m x n): Smoothed data set.					
%#											
%# AUTHOR:	Frederic Despagne							
%#		Copyright(c) 1997 for ChemoAC						
%#		Dienst FABI, Vrije Universiteit Brussel					
%#		Laarbeeklaan 103, 1090 Jette						
%#											
%# VERSION: 1.1 (28/02/1998)								
%#											
%# TEST:	Luisa Pasti								
%#											

function [smdata] = SMOOTH(data,window)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n] = size(data);	% Dimensions of the original data matrix
smdata = zeros(m,n);	% Initialization of the smoothed data matrix

if nargin == 1
	window = 3;	% Default window size
elseif round(window/2) == window/2
	error('The window size must be an odd integer')
end

wcenter = floor(window/2);
extdata = [zeros(m,wcenter) data zeros(m,wcenter)];	% Extended data matrix


%%%%%%%%%%%%%%%%%%%%%%%%%%%  EXTRAPOLATION AT THE EXTREMITIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:m
	bstart = polyfit(wcenter+1:wcenter+4,extdata(k,wcenter+1:wcenter+4),2);		% Fitting of left end
	bend = polyfit(n-4+wcenter:n+wcenter,extdata(k,n-4+wcenter:n+wcenter),2);	% Fitting of right end
	extdata(k,1:wcenter) = polyval(bstart,1:wcenter);				% Extrapolation at left end
	extdata(k,n+wcenter+1:n+window-1) = polyval(bend,n+wcenter+1:n+window-1);	% Extrapolation at right end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SMOOTHING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:n
	smdata(:,i) = mean(extdata(:,i:i+window-1)')';	% Average smoothing
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


