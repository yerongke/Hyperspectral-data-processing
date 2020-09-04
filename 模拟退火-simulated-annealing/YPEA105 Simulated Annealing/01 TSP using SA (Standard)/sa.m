%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA105
% Project Title: Simulated Annealing for Traveling Salesman Problem
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

model=CreateModel();    % Create Problem Model

CostFunction=@(tour) TourLength(tour,model);    % Cost Function

%% SA Parameters

MaxIt=250;      % Maximum Number of Iterations

MaxSubIt=15;    % Maximum Number of Sub-iterations

T0=0.025;       % Initial Temp.

alpha=0.99;     % Temp. Reduction Rate

%% Initialization

% Create and Evaluate Initial Solution
sol.Position=CreateRandomSolution(model);
sol.Cost=CostFunction(sol.Position);

% Initialize Best Solution Ever Found
BestSol=sol;

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Intialize Temp.
T=T0;

%% SA Main Loop

for it=1:MaxIt
    
    for subit=1:MaxSubIt
        
        % Create and Evaluate New Solution
        newsol.Position=CreateNeighbor(sol.Position);
        newsol.Cost=CostFunction(newsol.Position);
        
        if newsol.Cost<=sol.Cost % If NEWSOL is better than SOL
            sol=newsol;
            
        else % If NEWSOL is NOT better than SOL
            
            DELTA=(newsol.Cost-sol.Cost)/sol.Cost;
            
            P=exp(-DELTA/T);
            if rand<=P
                sol=newsol;
            end
            
        end
        
        % Update Best Solution Ever Found
        if sol.Cost<=BestSol.Cost
            BestSol=sol;
        end
    
    end
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Update Temp.
    T=alpha*T;
    
    % Plot Best Solution
    figure(1);
    PlotSolution(BestSol,model);
    pause(0.01);
    
end

%% Results

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
