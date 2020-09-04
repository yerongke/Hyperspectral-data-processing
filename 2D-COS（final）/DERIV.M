%#									
%#  function [dx] = deriv(x,der,window,order)				
%#									
%#  AIM: 	Derivative computation by using the Savitsky-Golay				 		
%#		algorithm. 		 				
%#									
%#  PRINCIPLE:  Differentiation by convolution method. 		 	
%#									
%#  INPUT:	x	- Data Matrix: (nxm) n spectra m variables	
%#		der	- (1x1) degree of the derivative; 		
%#			  it must be <= order				
%#		window	- (optional), (1x1) the number of points  	
%#			  in filter, it must be >3 and odd	
%#		order	- (optional), (1x1) the order of the polynomial 
%#			  It must be <=5 and <= (window-1)					   					
%#								
%#  OUTPUT:	dx	- Matrix of differentiated function (nxm)	
%#									
%#  SUBROUTINE:								
%#		weight.m						
%#		genfact.m						
%#		grampoly.m						
%#								
%#  AUTHOR: 	Luisa Pasti	 				 	
%#	    	Copyright(c) 1997 for ChemoAc				
%#          	FABI, Vrije Universiteit Brussel            		
%#          	Laarbeeklaan 103 1090 Jette				
%#		Modified program of					
%#		Sijmen de Jong						
%#		Unilever Research Laboratorium Vlaardingen		
%#    	    								
%# VERSION: 1.1 (28/02/1998)								 
%#									
%#  TEST:   	Kris De Braekeleer		                        
%#									

function dx = deriv(x,der,window,order)

[nr,nc]=size(x);
if (nargin<4)
  order = 2;  
  disp('  Polynomial order set to 2')
end
if (nargin<3)  
  window=min(17,floor(nc/2)); 
  disp(['  Windows size set to ',num2str(window)]);
end
if (nargin<2)
  disp(' function dx = deriv(x,der)')
end   		

m = fix(window/2); 	

p = round(window/2);

o=order;

for i=1:window
    i0=i-p;
    for j=1:window,
       j0=j-p;
       w(i,j)=weight(i0,j0,m,o,der);
    end
end
yr(:,1:m)=x(:,[1:window])*w(:,1:m);		% First window
for i=1:(nc-2*m)				% Middle
    yr(:,i+m)=x(:,[i:(i+2*m)])*w(:,p);
end
a=nc-2*m;					% Last window
yr(:,(nc-m+1):nc)=x(:,a:nc)*w(:,p+1:window); 
dx=yr;


end
