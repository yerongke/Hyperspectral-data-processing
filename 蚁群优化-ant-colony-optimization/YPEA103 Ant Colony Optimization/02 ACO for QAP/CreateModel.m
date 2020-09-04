%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YOEA103
% Project Title: Ant Colony Optimization for Quadratic Assignment Problem
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function model=CreateModel()

    x=[67 80 62 34 54 36 53 46 39 35 83 58 87 90 83 38 26 78 49 67];
    
    y=[9 81 9 43 89 30 95 87 1 74 85 86 56 86 22 73 36 34 17 37];
    
    m=numel(x);
    
    d=zeros(m,m);
    for p=1:m-1
        for q=p+1:m
            d(p,q)=sqrt((x(p)-x(q))^2+(y(p)-y(q))^2);
            d(q,p)=d(p,q);
        end
    end
    
    w=[0    6    6    3    5    5    5
       6    0    6    4  -10    3    6
       6    6    0    4    5    8    6
       3    4    4    0    4    4  100
       5  -10    5    4    0    3    4
       5    3    8    4    3    0    4
       5    6    6  100    4    4    0];

    n=size(w,1);
    
    model.n=n;
    model.m=m;
    model.w=w;
    model.x=x;
    model.y=y;
    model.d=d;
    
end