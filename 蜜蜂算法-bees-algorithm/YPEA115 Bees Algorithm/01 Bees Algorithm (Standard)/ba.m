%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA115
% Project Title: Implementation of Standard Bees Algorithm in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

clc;
clear;
close all;

%% Problem Definition

CostFunction=@(x) Sphere(x);        % Cost Function

nVar=5;             % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

VarMin=-10;         % Decision Variables Lower Bound
VarMax= 10;         % Decision Variables Upper Bound

%% Bees Algorithm Parameters

MaxIt=1000;          % Maximum Number of Iterations

nScoutBee=30;                           % Number of Scout Bees

nSelectedSite=round(0.5*nScoutBee);     % Number of Selected Sites

nEliteSite=round(0.4*nSelectedSite);    % Number of Selected Elite Sites

nSelectedSiteBee=round(0.5*nScoutBee);  % Number of Recruited Bees for Selected Sites

nEliteSiteBee=2*nSelectedSiteBee;       % Number of Recruited Bees for Elite Sites

r=0.1*(VarMax-VarMin);	% Neighborhood Radius

rdamp=0.95;             % Neighborhood Radius Damp Rate

%% Initialization

% Empty Bee Structure
empty_bee.Position=[];
empty_bee.Cost=[];

% Initialize Bees Array
bee=repmat(empty_bee,nScoutBee,1);

% Create New Solutions
for i=1:nScoutBee
    bee(i).Position=unifrnd(VarMin,VarMax,VarSize);
    bee(i).Cost=CostFunction(bee(i).Position);
end

% Sort
[~, SortOrder]=sort([bee.Cost]);
bee=bee(SortOrder);

% Update Best Solution Ever Found
BestSol=bee(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

%% Bees Algorithm Main Loop

for it=1:MaxIt
    
    % Elite Sites
    for i=1:nEliteSite
        
        bestnewbee.Cost=inf;
        
        for j=1:nEliteSiteBee
            newbee.Position=PerformBeeDance(bee(i).Position,r);
            newbee.Cost=CostFunction(newbee.Position);
            if newbee.Cost<bestnewbee.Cost
                bestnewbee=newbee;
            end
        end

        if bestnewbee.Cost<bee(i).Cost
            bee(i)=bestnewbee;
        end
        
    end
    
    % Selected Non-Elite Sites
    for i=nEliteSite+1:nSelectedSite
        
        bestnewbee.Cost=inf;
        
        for j=1:nSelectedSiteBee
            newbee.Position=PerformBeeDance(bee(i).Position,r);
            newbee.Cost=CostFunction(newbee.Position);
            if newbee.Cost<bestnewbee.Cost
                bestnewbee=newbee;
            end
        end

        if bestnewbee.Cost<bee(i).Cost
            bee(i)=bestnewbee;
        end
        
    end
    
    % Non-Selected Sites
    for i=nSelectedSite+1:nScoutBee
        bee(i).Position=unifrnd(VarMin,VarMax,VarSize);
        bee(i).Cost=CostFunction(bee(i).Position);
    end
    
    % Sort
    [~, SortOrder]=sort([bee.Cost]);
    bee=bee(SortOrder);
    
    % Update Best Solution Ever Found
    BestSol=bee(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Damp Neighborhood Radius
    r=r*rdamp;
    
end

%% Results

figure;
%plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');

