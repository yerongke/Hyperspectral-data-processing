%#									
%#  function [gf] = genfact(a,b)					
%#									
%#  AIM: 	Derivative computation by using the Savitsky-Golay		 		
%#		algorithm: Weight computation.  			
%#									
%#  PRINCIPLE:  Calculates the generalized factorial (a), (a-1)... 	
%# 									
%#  INPUT:	a	- equal to 2*m, m is the length of the filter	
%#		b	- index of the data point		 	
%#									
%#  OUTPUT:	gf	- generalized factorial vector			
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

function gf=genfact(a,b)
gf=1;
for i=(a-b+1):a
  gf=gf*i;
end
