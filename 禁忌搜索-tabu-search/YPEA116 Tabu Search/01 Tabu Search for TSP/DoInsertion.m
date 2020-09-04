%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA116
% Project Title: Implementation of Tabu Search for TSP
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function q=DoInsertion(p,i1,i2)
    if i1<i2
        q=p([1:i1-1 i1+1:i2 i1 i2+1:end]);
    else
        q=p([1:i2 i1 i2+1:i1-1 i1+1:end]);
    end
end