function p = betacdf(x,a,b);
%BETACDF Beta cumulative distribution function.
%	P = BETACDF(X,A,B) returns the beta cumulative distribution
%	function with parameters A and B at the values in X.
%
%	The size of P is the common size of the input arguments. A scalar input  
%	functions as a constant matrix of the same size as the other inputs.	 
%
%	BETAINC does the computational work.

%	Reference:
%	   [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%	   Functions", Government Printing Office, 1964, 26.5.

%	Copyright (c) 1993 by The MathWorks, Inc.
%	$Revision: 1.1 $  $Date: 1993/05/24 18:53:16 $

if nargin<3, 
   error('Requires three input arguments.'); 
end

[errorcode x a b] = distchck(3,x,a,b);

if errorcode > 0
   error('The arguments must be the same size or be scalars.');
end

% Initialize P to 0.
p = zeros(size(x));

k1 = find(a<=0 | b<=0);
if any(k1)
   p(k1) = NaN * ones(size(k1)); 
end

% If is X >= 1 the cdf of X is 1. 
k2 = find(x >= 1);
if any(k2)
   p(k2) = ones(size(k2));
end

k = find(x > 0 & x < 1 & a > 0 & b > 0);
if any(k)
   p(k) = betainc(x(k),a(k),b(k));
end

% Make sure that round-off errors never make P greater than 1.
k = find(p > 1);
p(k) = ones(size(k));
