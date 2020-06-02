%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML122
% Project Title: Feature Selection using SA and ACO (Fixed Number of Features)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function tour2=CreateNeighbor(tour1)

    pSwap=0.2;
    pReversion=0.5;
    pInsertion=1-pSwap-pReversion;
    
    p=[pSwap pReversion pInsertion];
    
    METHOD=RouletteWheelSelection(p);
    
    switch METHOD
        case 1
            % Swap
            tour2=ApplySwap(tour1);
            
        case 2
            % Reversion
            tour2=ApplyReversion(tour1);
            
        case 3
            % Insertion
            tour2=ApplyInsertion(tour1);
            
    end

end