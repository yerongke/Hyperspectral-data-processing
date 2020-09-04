%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA110
% Project Title: Implementation of Shuffled Complex Evolution (SCE-UA)
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

% Objective Function
CostFunction = @(x) Sphere(x);

nVar = 10;              % Number of Unknown Variables
VarSize = [1 nVar];     % Unknown Variables Matrix Size

VarMin = -10;           % Lower Bound of Unknown Variables
VarMax =  10;           % Upper Bound of Unknown Variables


%% SCE-UA Parameters

MaxIt = 500;        % Maximum Number of Iterations

nPopComplex = 10;                       % Complex Size
nPopComplex = max(nPopComplex, nVar+1); % Nelder-Mead Standard

nComplex = 5;                   % Number of Complexes
nPop = nComplex*nPopComplex;    % Population Size

I = reshape(1:nPop, nComplex, []);

% CCE Parameters
cce_params.q = max(round(0.5*nPopComplex),2);   % Number of Parents
cce_params.alpha = 3;   % Number of Offsprings
cce_params.beta = 5;    % Maximum Number of Iterations
cce_params.CostFunction = CostFunction;
cce_params.VarMin = VarMin;
cce_params.VarMax = VarMax;

%% Initialization

% Empty Individual Template
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Initialize Population Members
for i=1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
end

% Sort Population
pop = SortPopulation(pop);

% Update Best Solution Ever Found
BestSol = pop(1);

% Initialize Best Costs Record Array
BestCosts = nan(MaxIt, 1);

%% SCE-UA Main Loop

for it = 1:MaxIt
    
    % Initialize Complexes Array
    Complex = cell(nComplex, 1);
    
    % Form Complexes and Run CCE
    for j = 1:nComplex
        % Complex Formation
        Complex{j} = pop(I(j,:));
        
        % Run CCE
        Complex{j} = RunCCE(Complex{j}, cce_params);
        
        % Insert Updated Complex into Population
        pop(I(j,:)) = Complex{j};
    end
    
    % Sort Population
    pop = SortPopulation(pop);
    
    % Update Best Solution Ever Found
    BestSol = pop(1);
    
    % Store Best Cost Ever Found
    BestCosts(it) = BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
    
end

%% Results

figure;
%plot(BestCosts, 'LineWidth', 2);
semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
