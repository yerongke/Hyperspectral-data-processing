clc;
clear;
close all;
format shortG
%% Insert Data

data=InsertData();


nvar = data.nvar;           % Number of Decision Variables
SizeX = [1 nvar];     % Decision Variables Matrix Size

lb = -1*ones(1,nvar);       % Lower Bound of Decision Variables
ub = 1*ones(1,nvar);        % Upper Bound of Decision Variables

%% IWO Parameters

Maxiter =200;    % Maximum Number of iterations

npop0 = 40;     % Initerial Population Size
npop = npop0*4;     % Maximum Population Size

Smin = 0;       % Minimum Number of Seeds
Smax = 5;       % Maximum Number of Seeds

Exponent = 2;           % Variance Reduction Exponent
sigma_initerial = 1;      % Initerial Value of Standard Deviation
sigma_final = 0.001;	% Final Value of Standard Deviation

%% Initerialization
tic
% Empty Plant Structure
emp.x = [];
emp.fit = [];
emp.info = [];

pop = repmat(emp, npop0, 1);    % Initerial Population Array

for i = 1:numel(pop)
    
    % Initerialize x
    pop(i).x = unifrnd(lb, ub);
    
    % Evaluation
    pop(i)= fitness(pop(i),data);
    
end

% Initerialize Best fit History
BEST = zeros(Maxiter, 1);

%% IWO Main Loop

for iter = 1:Maxiter
    
    % Update Standard Deviation
    sigma = ((Maxiter - iter)/(Maxiter - 1))^Exponent * (sigma_initerial - sigma_final) + sigma_final;
    
    % Get Best and Worst fit Values
    fits = [pop.fit];
    Bestfit = min(fits);
    Worstfit = max(fits);
    
    % Initerialize Offsprings Population
    newpop = [];
    
    % Reproduction
    for i = 1:numel(pop)
        
        ratio = (pop(i).fit - Worstfit)/(Bestfit - Worstfit);
        S = floor(Smin + (Smax - Smin)*ratio);
        
        for j = 1:S
            
            % Initerialize Offspring
            newsol = emp;
            
            % Generate Random Location
            newsol.x = pop(i).x + sigma * randn(SizeX);
            
            % Apply Lower/Upper Bounds
            newsol.x = CB(newsol.x, lb,ub);
       
            
            % Evaluate Offsring
            newsol = fitness(newsol,data);
            
            % Add Offpsring to the Population
            newpop = [newpop
                      newsol];  %#ok
            
        end
        
    end
    
    % Merge Populations
    [pop] = [pop
           newpop];
    
    % Sort Population
    [~, ind]=sort([pop.fit]);
    pop = pop(ind);

    % Competiterive Exclusion (Delete Extra Members)
    if numel(pop)>npop
        pop = pop(1:npop);
    end
    
    % Store Best Solution Ever Found
    gpop = pop(1); % gpop: global Solution
    
    % Store Best fit History
    BEST(iter) = gpop.fit;
    
    % Display iteration Information
    disp(['iter ' num2str(iter) ' Best = ' num2str(BEST(iter))]);
    
end

%% Results
disp([ ' Best Solution = ' num2str(gpop.x) ])
disp([ ' Best fitness = ' num2str(gpop.fit) ])
disp([ ' Time = ' num2str(toc) ])


figure;
semilogy(BEST,'LineWidth',2);
xlabel('iteration');
ylabel('Fitness');
title('IWO')


net=gpop.info.net;
ShowResults(net);
