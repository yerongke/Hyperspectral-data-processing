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

function i=TournamentSelection(pop,m)

    nPop=numel(pop);

    S=randsample(nPop,m);
    
    spop=pop(S);
    
    scosts=[spop.Cost];
    
    [~, j]=min(scosts);
    
    i=S(j);

end