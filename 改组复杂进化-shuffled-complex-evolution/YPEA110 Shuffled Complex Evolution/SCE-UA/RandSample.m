%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA110
% Project Title: Implementation of Shuffled Complex Evolution (SCE-UA)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function L = RandSample(P, q, replacement)

    if ~exist('replacement','var')
        replacement = false;
    end

    L = zeros(q,1);
    for i=1:q
        L(i) = randsample(numel(P), 1, true, P);
        if ~replacement
            P(L(i)) = 0;
        end
    end

end