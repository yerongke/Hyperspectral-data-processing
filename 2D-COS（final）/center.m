%#										
%#  function [cdata,me,ctest]=center(data,opt,newdata);			
%#										
%#  AIM: 	Centering along columns, rows or double centering		
%#										
%#  PRINCIPLE:  Removal of the column-, row- or overall mean from 		
%#              each column, row or both, respectively 		 		
%# 				 If a test data set is available it can ONLY be 
%#              column centered using the mean from the calibration
%#              data set.
%#
%#
%#  INPUT:	data: (m x n) matrix with m rows and n variables		
%#				opt: optional							
%#		     1 = column centering					
%#		     2 = row centering						
%#		     3 = double centering					
%#          newdata: (mt x n) test matrix with mt rows and n variables
%#					
%#			 							
%#  OUTPUT:	cdata: (m x n) matrix containing centered data			
%#				me: mean vector, overall mean (scalar)
%#              newdata: (mt*n) test matrix centered with the mean of data
%#	
%#										
%#  AUTHOR: 	Andrea Candolfi				 			
%#	    			Copyright(c) 1997 for ChemoAc					
%#          	FABI, Vrije Universiteit Brussel            			
%#          	Laarbeeklaan 103 1090 Jette					
%#   										
%# VERSION: 1.2 (25/02/2002)							
%#										
%#  TEST:   	I. Stanimirova	& S. Gourvénec & M. Zhang
%#										
	
function [cdata,me,cnewdata]=center(data,opt,newdata);

[m,n]=size(data);

if nargin==1;
  opt=[4];
  while opt>3 | opt<=0 
    opt=input('column centering(1), row centering(2), double centering(3):');
  end
end


if opt==1			% column centering 
   me=mean(data);
   cdata=data-ones(m,1)*me;
end

if opt==2			% row centering
   me=mean(data')';
   cdata=data-me*ones(1,n);
end

if opt==3 	% double centering
   me=mean(mean(data));
   mej=mean(data');
   mei=mean(data);
   cdata=data-(ones(m,1)*mei)-(ones(n,1)*mej)'+(ones(m,n)*me);
end

if exist('newdata')==1			% center new data
    [mt,n]=size(newdata);
    
    if opt==1				% column centering 
        me=mean(data);
        cnewdata=newdata-ones(mt,1)*me;
    else
        error('Row centering and double centering are impossible to perform on a test set');
    end
    
end