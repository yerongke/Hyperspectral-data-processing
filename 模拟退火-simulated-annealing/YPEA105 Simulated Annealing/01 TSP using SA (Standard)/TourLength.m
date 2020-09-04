%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA105
% Project Title: Simulated Annealing for Traveling Salesman Problem
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function L=TourLength(tour,model)

    n=numel(tour);
    
    tour=[tour tour(1)];
    
    L=0;
    
    for k=1:n
        
        i=tour(k);
        j=tour(k+1);
        
        L=L+model.d(i,j);
        
    end

end