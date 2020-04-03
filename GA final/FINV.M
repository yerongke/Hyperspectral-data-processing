function x = finv(p,v1,v2);
%FINV	Inverse of the F cumulative distribution function.
%	X=FINV(P,V1,V2) returns the inverse of the F distribution 
%	function with V1 and V2 degrees of freedom, at the values in Y.
%
%	The size of X is the common size of the input arguments. A scalar input  
%	functions as a constant matrix of the same size as the other inputs.	 

%	References:
%	   [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%	   Functions", Government Printing Office, 1964, 26.6.2

%	Copyright (c) 1993 by The MathWorks, Inc.
%	$Revision: 1.1 $  $Date: 1993/05/24 18:54:27 $

if nargin <  3, 
    error('Requires three input arguments.'); 
end

[errorcode p v1 v2] = distchck(3,p,v1,v2);

if errorcode > 0
    error('The arguments must be the same size or be scalars.');
end

%   Initialize Z to zero.
z = zeros(size(p));
x = zeros(size(p));

k = find(v1 <= 0 | v2 <= 0 | v1 ~= round(v1) | v2 ~= round(v2));
if any(k)
   x(k) = NaN * ones(size(k));
end

k1 = find(p > 0 & p < 1 & v1 > 0 & v2 > 0 & v1 == round(v1) & v2 == round(v2));
if any(k1)
    z = betainv(1 - p(k1),v2(k1)/2,v1(k1)/2);
    x(k1) = (v2(k1) ./ z - v2(k1)) ./ v1(k1);
end

k2 = find(p == 1 & v1 > 0 & v2 > 0 & v1 == round(v1) & v2 == round(v2));
if any(k2)
    x(k2) = Inf * ones(size(k2));
end
