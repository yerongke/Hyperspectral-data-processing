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

function emp=InterEmpireCompetition(emp)

    if numel(emp)==1
        return;
    end

    global ICASettings;
    alpha=ICASettings.alpha;

    TotalCost=[emp.TotalCost];
    
    [~, WeakestEmpIndex]=max(TotalCost);
    WeakestEmp=emp(WeakestEmpIndex);
    
    P=exp(-alpha*TotalCost/max(TotalCost));
    P(WeakestEmpIndex)=0;
    P=P/sum(P);
    if any(isnan(P))
        P(isnan(P))=0;
        if all(P==0)
            P(:)=1;
        end
        P=P/sum(P);
    end
        
    if WeakestEmp.nCol>0
        [~, WeakestColIndex]=max([WeakestEmp.Col.Cost]);
        WeakestCol=WeakestEmp.Col(WeakestColIndex);

        WinnerEmpIndex=RouletteWheelSelection(P);
        WinnerEmp=emp(WinnerEmpIndex);

        WinnerEmp.Col(end+1)=WeakestCol;
        WinnerEmp.nCol=WinnerEmp.nCol+1;
        emp(WinnerEmpIndex)=WinnerEmp;

        WeakestEmp.Col(WeakestColIndex)=[];
        WeakestEmp.nCol=WeakestEmp.nCol-1;
        emp(WeakestEmpIndex)=WeakestEmp;
    end
    
    if WeakestEmp.nCol==0
        
        WinnerEmpIndex2=RouletteWheelSelection(P);
        WinnerEmp2=emp(WinnerEmpIndex2);
        
        WinnerEmp2.Col(end+1)=WeakestEmp.Imp;
        WinnerEmp2.nCol=WinnerEmp2.nCol+1;
        emp(WinnerEmpIndex2)=WinnerEmp2;
        
        emp(WeakestEmpIndex)=[];
    end
    
end