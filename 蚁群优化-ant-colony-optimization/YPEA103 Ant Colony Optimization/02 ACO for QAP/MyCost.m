%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YOEA103
% Project Title: Ant Colony Optimization for Quadratic Assignment Problem
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function z=MyCost(p,model)

    n=model.n;
    w=model.w;
    d=model.d;

    z=0;
    
    for i=1:n-1
        for j=i+1:n
            
            z=z+w(i,j)*d(p(i),p(j));
            
        end
    end

end