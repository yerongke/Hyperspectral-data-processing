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

function tour2=ApplyInsertion(tour1)

    n=numel(tour1);
    
    I=randsample(n,2);
    
    i1=I(1);
    i2=I(2);
    
    if i1<i2
        tour2=tour1([1:i1-1 i1+1:i2 i1 i2+1:end]);
    else
        tour2=tour1([1:i2 i1 i2+1:i1-1 i1+1:end]);
    end
    
end