%#  function [Xcal,Xtest,Ycal,Ytest,ind1,ind2,indrem] = duplex(X,Y,np)		
%#											
%#  AIM: 	Duplex algorithm for sample subset selection in a data set.		
%#											
%#  PRINCIPLE:  This algorithm starts by selecting the two points furthest from each 	
%#		other (euclidean distance) and puts them both in a first set. 		
%#		Then the next two points furthest from each other are put in a second	
%#		set, and the procedure is continued by alternatively placing pairs of 	
%#		points in the first or second set. For calibration applications, the	
%#		second set can be the test set, and the calibration would be the 	
%#		concatenation of the first set plus the remaining samples.		
%#											
%#  REFERENCE:	RD Snee, Technometrics 19 (1977) 415-428				
%# 											
%#  INPUT:	X (n*m) : data matrix (original variables or scores)			
%#          Y (1*n) : matrix of predicted variables
%#		np : number of points to select in each set (optional, default 50%)	
%#											
%#  OUTPUT:	ind1 (1*np) : indices of samples in the first set			
%#		      ind2 (1*np) : indices of samples in the second set			
%#		      indrem (1*(n-2*np)) : indices of remaining samples			
%#											
%#  AUTHOR: 	Jorge Verdu Andres 								
%#	      	Copyright(c) 1997 for ChemoAC						
%#          	FABI, Vrije Universiteit Brussel            				
%#          	Laarbeeklaan 103 1090 Jette						
%#    	    										
%# VERSION: 1.1 (28/02/98)								
%#										
%# TEST:   	Frederic Despagne, Menghui Zhang (2002)							

function [Xcal,Xtest,Ycal,Ytest,ind1,ind2,indrem] = duplex(X,Y,np)

x = X;
[n,p] = size(x);
index = 1:n;

if nargin == 1 
	np = floor(.5*n); 	% Default number of samples per subset (50%)
elseif np > floor(.5*n)
	error('You can not select more than half the total number of samples in each subset')
else	
	np = round(np);
end
infoo=[];
% Block to select the first two points that are furthest apart in the first set
for i = 1:n-1
	d = (x(i+1:n,:)-ones(n-i,1)*x(i,:)).^2;
	d = sum(d');
	[a,b] = max(d);
	infoo = [infoo;i b+i a];
end 

[a,b] = max(infoo(:,3));
ind1 = [infoo(b,1) infoo(b,2)];
index(ind1) = [];
infoo = [];
x(ind1,:) = [];

% Block to select the next two points that are furthest apart in the second set
for i = 1:n-3
	d = (x(i+1:n-2,:)-ones(n-i-2,1)*x(i,:)).^2;
	d = sum(d');
	[a,b] = max(d);
	infoo=[infoo;i b+i a];
end 

[a,b] = max(infoo(:,3));
ind2 = [index(infoo(b,1)) index(infoo(b,2))];
index([infoo(b,1) infoo(b,2)]) = [];
infoo = [];
x(ind2,:) = [];

while length(ind1) < np
	delta = [];

	% Computing the distances between the remaining points and the points previously 
	% selected in the first set
	for j = 1:length(index)
		d = (X(ind1,:)-ones(length(ind1),1)*X(index(j),:)).^2;
		d = sum(d');
		delta(j) = min(d);
	end 

	[a,b] = max(delta);
	ind1 = [ind1 index(b)];
	index(b) = [];

	% Computing the distances between the remaining points and the points previously 
	% selected in the second set
	delta = [];
	for j = 1:length(index)
		d = (X(ind2,:)-ones(length(ind2),1)*X(index(j),:)).^2;
		d = sum(d');
		delta(j) = min(d);
	end 

	[a,b] = max(delta);
	ind2 = [ind2 index(b)];
	index(b) = [];

	% Indices of remaining points
	indrem = 1:n;
	indrem([ind1 ind2]) = [];

end 

indcal=[ind1 indrem];
Xcal=X(indcal,:);
Ycal=Y(indcal,:)
Xtest=X(ind2,:);
Ytest=Y(ind2,:);