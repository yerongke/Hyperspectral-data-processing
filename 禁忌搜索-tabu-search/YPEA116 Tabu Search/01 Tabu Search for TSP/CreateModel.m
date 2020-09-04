%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA116
% Project Title: Implementation of Tabu Search for TSP
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function model=CreateModel()

    x=[82 91 12 92 63 9 28 55 96 97 15 98 96 49 80 12 80 55];
    
    y=[14 42 92 80 96 66 3 85 94 68 76 75 39 66 17 78 80 45];
    
    n=numel(x);
    
    d=zeros(n,n);
    
    for i=1:n-1
        for j=i+1:n
            d(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            d(j,i)=d(i,j);
        end
    end

    xmin=0;
    xmax=100;
    
    ymin=0;
    ymax=100;
    
    model.n=n;
    model.x=x;
    model.y=y;
    model.d=d;
    model.xmin=xmin;
    model.xmax=xmax;
    model.ymin=ymin;
    model.ymax=ymax;
    
end