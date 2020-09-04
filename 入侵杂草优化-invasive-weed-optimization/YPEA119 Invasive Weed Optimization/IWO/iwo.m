%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA119
% Project Title: Implementation of Invasive Weed Optimization in MATLAB
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

CostFunction = @(x) Sphere(x);  % Objective Function

nVar = 5;           % Number of Decision Variables
VarSize = [1 nVar]; % Decision Variables Matrix Size

VarMin = -10;       % Lower Bound of Decision Variables
VarMax = 10;        % Upper Bound of Decision Variables

%% IWO Parameters

MaxIt = 200;    % Maximum Number of Iterations

nPop0 = 10;     % Initial Population Size
nPop = 25;      % Maximum Population Size

Smin = 0;       % Minimum Number of Seeds
Smax = 5;       % Maximum Number of Seeds

Exponent = 2;           % Variance Reduction Exponent
sigma_initial = 0.5;    % Initial Value of Standard Deviation
sigma_final = 0.001;	% Final Value of Standard Deviation

%% Initialization

% Empty Plant Structure
empty_plant.Position = [];
empty_plant.Cost = [];

pop = repmat(empty_plant, nPop0, 1);    % Initial Population Array

for i = 1:numel(pop)
    
    % Initialize Position
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    
    % Evaluation
    pop(i).Cost = CostFunction(pop(i).Position);
    
end

% Initialize Best Cost History
BestCosts = zeros(MaxIt, 1);

%% IWO Main Loop

for it = 1:MaxIt
    
    % Update Standard Deviation
    sigma = ((MaxIt - it)/(MaxIt - 1))^Exponent * (sigma_initial - sigma_final) + sigma_final;
    
    % Get Best and Worst Cost Values
    Costs = [pop.Cost];
    BestCost = min(Costs);
    WorstCost = max(Costs);
    
    % Initialize Offsprings Population
    newpop = [];
    
    % Reproduction
    for i = 1:numel(pop)
        
        ratio = (pop(i).Cost - WorstCost)/(BestCost - WorstCost);
        S = floor(Smin + (Smax - Smin)*ratio);
        
        for j = 1:S
            
            % Initialize Offspring
            newsol = empty_plant;
            
            % Generate Random Location
            newsol.Position = pop(i).Position + sigma * randn(VarSize);
            
            % Apply Lower/Upper Bounds
            newsol.Position = max(newsol.Position, VarMin);
            newsol.Position = min(newsol.Position, VarMax);
            
            % Evaluate Offsring
            newsol.Cost = CostFunction(newsol.Position);
            
            % Add Offpsring to the Population
            newpop = [newpop
                      newsol];  %#ok
            
        end
        
    end
    
    % Merge Populations
    pop = [pop
           newpop];
    
    % Sort Population
    [~, SortOrder]=sort([pop.Cost]);
    pop = pop(SortOrder);

    % Competitive Exclusion (Delete Extra Members)
    if numel(pop)>nPop
        pop = pop(1:nPop);
    end
    
    % Store Best Solution Ever Found
    BestSol = pop(1);
    
    % Store Best Cost History
    BestCosts(it) = BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
    
end

%% Results

figure;
% plot(BestCosts,'LineWidth',2);
semilogy(BestCosts,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
