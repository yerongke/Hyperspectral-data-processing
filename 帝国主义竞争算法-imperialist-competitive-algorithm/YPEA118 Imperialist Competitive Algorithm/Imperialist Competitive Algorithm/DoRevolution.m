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

function emp=DoRevolution(emp)

    global ProblemSettings;
    CostFunction=ProblemSettings.CostFunction;
    nVar=ProblemSettings.nVar;
    VarSize=ProblemSettings.VarSize;
    VarMin=ProblemSettings.VarMin;
    VarMax=ProblemSettings.VarMax;
    
    global ICASettings;
    pRevolution=ICASettings.pRevolution;
    mu=ICASettings.mu;
    
    nmu=ceil(mu*nVar);
    
    sigma=0.1*(VarMax-VarMin);
    
    nEmp=numel(emp);
    for k=1:nEmp
        
        NewPos = emp(k).Imp.Position + sigma*randn(VarSize);
        
        jj=randsample(nVar,nmu)';
        NewImp=emp(k).Imp;
        NewImp.Position(jj)=NewPos(jj);
        NewImp.Cost=CostFunction(NewImp.Position);
        if NewImp.Cost<emp(k).Imp.Cost
            emp(k).Imp = NewImp;
        end
        
        for i=1:emp(k).nCol
            if rand<=pRevolution

                NewPos = emp(k).Col(i).Position + sigma*randn(VarSize);
                
                jj=randsample(nVar,nmu)';
                emp(k).Col(i).Position(jj) = NewPos(jj);

                emp(k).Col(i).Position = max(emp(k).Col(i).Position,VarMin);
                emp(k).Col(i).Position = min(emp(k).Col(i).Position,VarMax);

                emp(k).Col(i).Cost = CostFunction(emp(k).Col(i).Position);

            end
        end
    end

end