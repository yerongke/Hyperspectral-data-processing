function s = sumsqr(a)
%SUMSQR Sum squared elements of a matrix.
%
%  Synopsis
%
%    sumsqr(m)
%
%  Description
%
%    SUMSQR(M) returns the sum of the squared elements in M.
%
%  Examples
%
%    s = sumsqr([1 2;3 4])

% Mark Beale, 1-31-92
% Copyright 1992-2005 The MathWorks, Inc.
% $Revision: 1.1.6.3 $  $Date: 2008/10/31 06:24:39 $

if nargin < 1,error('NNET:sumsqr:Arguments','Not enough input arguments.');end

s = sum(sum(a.*a));
