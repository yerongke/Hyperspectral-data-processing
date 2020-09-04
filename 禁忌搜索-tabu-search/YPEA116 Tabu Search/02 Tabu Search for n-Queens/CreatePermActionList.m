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

function ActionList=CreatePermActionList(n)

    nSwap=n*(n-1)/2;
    nReversion=n*(n-1)/2;
    nInsertion=n^2;
    nAction=nSwap+nReversion+nInsertion;
    
    ActionList=cell(nAction,1);
    
    c=0;
    
    % Add SWAP
    for i=1:n-1
        for j=i+1:n
            c=c+1;
            ActionList{c}=[1 i j];
        end
    end

    % Add REVERSION
    for i=1:n-1
        for j=i+1:n
            if abs(i-j)>2
                c=c+1;
                ActionList{c}=[2 i j];
            end
        end
    end
    
    % Add Insertion
    for i=1:n
        for j=1:n
            if abs(i-j)>1
                c=c+1;
                ActionList{c}=[3 i j];
            end
        end
    end
    
    ActionList=ActionList(1:c);

end