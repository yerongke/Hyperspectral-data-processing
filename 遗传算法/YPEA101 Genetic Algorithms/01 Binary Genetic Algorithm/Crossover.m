%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA101
% Project Title: Implementation of Binary Genetic Algorithm in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function [y1, y2]=Crossover(x1,x2)

    pSinglePoint=0.1;
    pDoublePoint=0.2;
    pUniform=1-pSinglePoint-pDoublePoint;
    
    METHOD=RouletteWheelSelection([pSinglePoint pDoublePoint pUniform]);
    
    switch METHOD
        case 1
            [y1, y2]=SinglePointCrossover(x1,x2);
            
        case 2
            [y1, y2]=DoublePointCrossover(x1,x2);
            
        case 3
            [y1, y2]=UniformCrossover(x1,x2);
            
    end

end