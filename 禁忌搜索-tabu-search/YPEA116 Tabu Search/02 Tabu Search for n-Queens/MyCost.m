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

function z=MyCost(x)

    n=numel(x);
    
    y=1:n;
    
    z=0;
    for i=1:n-1
        for j=i+1:n
            if abs(x(i)-x(j))==abs(y(i)-y(j))
                z=z+1;
            end
        end
    end

    % z=z/(n*(n-1)/2);  % Normalization
    
end