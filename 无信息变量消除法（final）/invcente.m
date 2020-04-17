%#									
%#  function [data]=invcente(cdata,me);					
%#									
%#  AIM: 	Inverse centering				 	
%#									
%#  PRINCIPLE:  Addition of the column-, row- or overall mean to 	
%#              each column, row or both, respectively. 		
%# 									
%#  INPUT:	cdata: (mt x nt) matrix containing centered data	
%#		me: mean vector, overall mean (scalar)			
%#		  if me (1 x n), column centering			
%#		  if me (m x 1), row centering				
%#		  if me (1 x 1), double centering			
%#		    CAVE: (m x m) matrix !!				
%#			 						
%#  OUTPUT:	data: (m x n) matrix with m objects and n variables											
%#									
%#  AUTHOR: 	Andrea Candolfi				 		
%#	    	Copyright(c) 1997 for ChemoAc				
%#          	FABI, Vrije Universiteit Brussel            		
%#          	Laarbeeklaan 103 1090 Jette				
%#    	    								
%# VERSION: 1.1 (28/02/1998)							 
%#									
%#  TEST:   	Roy de Maesschalck, Menghui Zhang (2002)					
%#									
	
function [data]=invcente(cdata,me);

[m,n]=size(cdata);
[mme,nme]=size(me);


if nme==n			% inverse column centering 
  data=cdata+ones(m,1)*me;
end

if mme==m			% inverse row centering
  data=cdata+me*ones(1,n);
end

if size(me)==1			% inverse double centering
  data=cdata+ones(m,n)*me;
end


  
