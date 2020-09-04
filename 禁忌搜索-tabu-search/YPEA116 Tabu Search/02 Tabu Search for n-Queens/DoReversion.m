%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA116
% Project Title: Implementation of Tabu Search for n-Queens Problem
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function q=DoReversion(p,i1,i2)
    q=p;
    if i1<i2
        q(i1:i2)=p(i2:-1:i1);
    else
        q(i1:-1:i2)=p(i2:i1);
    end
end