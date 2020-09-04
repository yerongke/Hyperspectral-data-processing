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

function emp=IntraEmpireCompetition(emp)

    nEmp=numel(emp);
    
    for k=1:nEmp
        for i=1:emp(k).nCol
            if emp(k).Col(i).Cost<emp(k).Imp.Cost
                imp=emp(k).Imp;
                col=emp(k).Col(i);
                
                emp(k).Imp=col;
                emp(k).Col(i)=imp;
            end
        end
    end

end