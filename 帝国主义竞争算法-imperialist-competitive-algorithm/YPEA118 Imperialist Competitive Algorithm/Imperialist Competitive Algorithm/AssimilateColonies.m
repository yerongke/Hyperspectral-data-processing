%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA118
% Project Title: Implementation of Imperialist Competitive Algorithm (ICA)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function emp=AssimilateColonies(emp)

    global ProblemSettings;
    CostFunction=ProblemSettings.CostFunction;
    VarSize=ProblemSettings.VarSize;
    VarMin=ProblemSettings.VarMin;
    VarMax=ProblemSettings.VarMax;
    
    global ICASettings;
    beta=ICASettings.beta;
    
    nEmp=numel(emp);
    for k=1:nEmp
        for i=1:emp(k).nCol
            
            emp(k).Col(i).Position = emp(k).Col(i).Position ...
                + beta*rand(VarSize).*(emp(k).Imp.Position-emp(k).Col(i).Position);
            
            emp(k).Col(i).Position = max(emp(k).Col(i).Position,VarMin);
            emp(k).Col(i).Position = min(emp(k).Col(i).Position,VarMax);
            
            emp(k).Col(i).Cost = CostFunction(emp(k).Col(i).Position);
            
        end
    end

end