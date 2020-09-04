%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA105
% Project Title: Population-based Simulated Annealing for TSP
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

MaxIt=100;      % Maximum Number of Iterations

MaxSubIt=10;    % Maximum Number of Sub-iterations

T0=0.025;       % Initial Temp.

alpha=0.99;     % Temp. Reduction Rate

nPop=3;         % Population Size

nMove=5;        % Number of Neighbors per Individual


%% Initialization

% Create Empty Structure for Individuals
empty_individual.Position=[];
empty_individual.Cost=[];

% Create Population Array
pop=repmat(empty_individual,nPop,1);

% Initialize Best Solution
BestSol.Cost=inf;

% Initialize Population
for i=1:nPop
    
    % Initialize Position
    pop(i).Position=CreateRandomSolution(model);
    
    % Evaluation
    pop(i).Cost=CostFunction(pop(i).Position);
    
    % Update Best Solution
    if pop(i).Cost<=BestSol.Cost
        BestSol=pop(i);
    end
    
end

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Intialize Temp.
T=T0;

%% SA Main Loop

for it=1:MaxIt
    
    for subit=1:MaxSubIt
        
        % Create and Evaluate New Solutions
        newpop=repmat(empty_individual,nPop,nMove);
        for i=1:nPop
            for j=1:nMove
                
                % Create Neighbor
                newpop(i,j).Position=CreateNeighbor(pop(i).Position);
                
                % Evaluation
                newpop(i,j).Cost=CostFunction(newpop(i,j).Position);
                
            end
        end
        newpop=newpop(:);
        
        % Sort Neighbors
        [~, SortOrder]=sort([newpop.Cost]);
        newpop=newpop(SortOrder);
        
        for i=1:nPop
            
            if newpop(i).Cost<=pop(i).Cost
                pop(i)=newpop(i);
                
            else
                DELTA=(newpop(i).Cost-pop(i).Cost)/pop(i).Cost;
                P=exp(-DELTA/T);
                if rand<=P
                    pop(i)=newpop(i);
                end
            end
            
            % Update Best Solution Ever Found
            if pop(i).Cost<=BestSol.Cost
                BestSol=pop(i);
            end
        
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
