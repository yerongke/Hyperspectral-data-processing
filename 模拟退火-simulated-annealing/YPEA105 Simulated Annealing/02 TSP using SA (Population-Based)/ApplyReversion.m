%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA105
% Project Title: Population-based Simulated Annealing for TSP
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function tour2=ApplyReversion(tour1)

    n=numel(tour1);
    
    I=randsample(n,2);
    
    i1=min(I);
    i2=max(I);
    
    tour2=tour1;
    tour2(i1:i2)=tour1(i2:-1:i1);
    
end