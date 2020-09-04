%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YOEA103
% Project Title: Ant Colony Optimization for Binary Knapsack Problem
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

model=CreateModel();

CostFunction=@(x) MyCost(x,model);

nVar=model.n;


%% ACO Parameters

MaxIt=300;      % Maximum Number of Iterations

nAnt=40;        % Number of Ants (Population Size)

Q=1;

tau0=0.1;        % Initial Phromone

alpha=1;        % Phromone Exponential Weight
beta=0.02;      % Heuristic Exponential Weight

rho=0.1;        % Evaporation Rate


%% Initialization

N=[0 1];

eta=[model.w./model.v
     model.v./model.w];           % Heuristic Information

tau=tau0*ones(2,nVar);      % Phromone Matrix

BestCost=zeros(MaxIt,1);    % Array to Hold Best Cost Values

% Empty Ant
empty_ant.Tour=[];
empty_ant.x=[];
empty_ant.Cost=[];
empty_ant.Sol=[];

% Ant Colony Matrix
ant=repmat(empty_ant,nAnt,1);

% Best Ant
BestSol.Cost=inf;


%% ACO Main Loop

for it=1:MaxIt
    
    % Move Ants
    for k=1:nAnt
        
        ant(k).Tour=[];
        
        for l=1:nVar
            
            P=tau(:,l).^alpha.*eta(:,l).^beta;
            
            P=P/sum(P);
            
            j=RouletteWheelSelection(P);
            
            ant(k).Tour=[ant(k).Tour j];
            
        end
        
        ant(k).x=N(ant(k).Tour);
        
        [ant(k).Cost, ant(k).Sol]=CostFunction(ant(k).x);
        
        if ant(k).Cost<BestSol.Cost
            BestSol=ant(k);
        end
        
    end
    
    % Update Phromones
    for k=1:nAnt
        
        tour=ant(k).Tour;
        
        for l=1:nVar
            
            tau(tour(l),l)=tau(tour(l),l)+Q/ant(k).Cost;
            
        end
        
    end
    
    % Evaporation
    tau=(1-rho)*tau;
    
    % Store Best Cost
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    if BestSol.Sol.IsFeasible
        FeasiblityFlag = '*';
    else
        FeasiblityFlag = '';
    end
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) ' ' FeasiblityFlag]);
    
end

%% Results

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
