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

function q=DoAction(p,a)

    switch a(1)
        case 1
            % Swap
            q=DoSwap(p,a(2),a(3));
            
        case 2
            % Reversion
            q=DoReversion(p,a(2),a(3));
            
        case 3
            % Insertion
            q=DoInsertion(p,a(2),a(3));
            
    end

end