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

function emp=CreateInitialEmpires()

    global ProblemSettings;
    global ICASettings;

    CostFunction=ProblemSettings.CostFunction;
    nVar=ProblemSettings.nVar;
    VarSize=ProblemSettings.VarSize;
    VarMin=ProblemSettings.VarMin;
    VarMax=ProblemSettings.VarMax;
    
    nPop=ICASettings.nPop;
    nEmp=ICASettings.nEmp;
    nCol=nPop-nEmp;
    alpha=ICASettings.alpha;
    
    empty_country.Position=[];
    empty_country.Cost=[];
    
    country=repmat(empty_country,nPop,1);
    
    for i=1:nPop

        country(i).Position=unifrnd(VarMin,VarMax,VarSize);
        
        country(i).Cost=CostFunction(country(i).Position);
        
    end

    
    costs=[country.Cost];
    [~, SortOrder]=sort(costs);
    
    country=country(SortOrder);
    
    imp=country(1:nEmp);
    
    col=country(nEmp+1:end);
    
    
    empty_empire.Imp=[];
    empty_empire.Col=repmat(empty_country,0,1);
    empty_empire.nCol=0;
    empty_empire.TotalCost=[];
    
    emp=repmat(empty_empire,nEmp,1);
    
    % Assign Imperialists
    for k=1:nEmp
        emp(k).Imp=imp(k);
    end
    
    % Assign Colonies
    P=exp(-alpha*[imp.Cost]/max([imp.Cost]));
    P=P/sum(P);
    for j=1:nCol
        
        k=RouletteWheelSelection(P);
        
        emp(k).Col=[emp(k).Col
                    col(j)];
        
        emp(k).nCol=emp(k).nCol+1;
    end
    
    emp=UpdateTotalCost(emp);
    
end