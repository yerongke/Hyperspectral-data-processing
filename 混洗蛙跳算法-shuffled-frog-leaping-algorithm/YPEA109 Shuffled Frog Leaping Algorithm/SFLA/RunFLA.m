%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA109
% Project Title: Implementation of Shuffled Frog Leaping Algorithm (SFLA)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function pop = RunFLA(pop, params)

    %% FLA Parameters
    q = params.q;           % Number of Parents
    alpha = params.alpha;   % Number of Offsprings
    beta = params.beta;     % Maximum Number of Iterations
    sigma = params.sigma;
    CostFunction = params.CostFunction;
    VarMin = params.VarMin;
    VarMax = params.VarMax;
    VarSize = size(pop(1).Position);
    BestSol = params.BestSol;
    
    nPop = numel(pop);      % Population Size
    P = 2*(nPop+1-(1:nPop))/(nPop*(nPop+1));    % Selection Probabilities
    
    % Calculate Population Range (Smallest Hypercube)
    LowerBound = pop(1).Position;
    UpperBound = pop(1).Position;
    for i = 2:nPop
        LowerBound = min(LowerBound, pop(i).Position);
        UpperBound = max(UpperBound, pop(i).Position);
    end
    
    %% FLA Main Loop

    for it = 1:beta
        
        % Select Parents
        L = RandSample(P,q);
        B = pop(L);
        
        % Generate Offsprings
        for k=1:alpha
            
            % Sort Population
            [B, SortOrder] = SortPopulation(B);
            L = L(SortOrder);
            
            % Flags
            ImprovementStep2 = false;
            Censorship = false;
            
            % Improvement Step 1
            NewSol1 = B(end);
            Step = sigma*rand(VarSize).*(B(1).Position-B(end).Position);
            NewSol1.Position = B(end).Position + Step;
            if IsInRange(NewSol1.Position, VarMin, VarMax)
                NewSol1.Cost = CostFunction(NewSol1.Position);
                if NewSol1.Cost<B(end).Cost
                    B(end) = NewSol1;
                else
                    ImprovementStep2 = true;
                end
            else
                ImprovementStep2 = true;
            end
            
            % Improvement Step 2
            if ImprovementStep2
                NewSol2 = B(end);
                Step = sigma*rand(VarSize).*(BestSol.Position-B(end).Position);
                NewSol2.Position = B(end).Position + Step;
                if IsInRange(NewSol2.Position, VarMin, VarMax)
                    NewSol2.Cost = CostFunction(NewSol2.Position);
                    if NewSol2.Cost<B(end).Cost
                        B(end) = NewSol2;
                    else
                        Censorship = true;
                    end
                else
                    Censorship = true;
                end
            end
                
            % Censorship
            if Censorship
                B(end).Position = unifrnd(LowerBound, UpperBound);
                B(end).Cost = CostFunction(B(end).Position);
            end
            
        end
        
        % Return Back Subcomplex to Main Complex
        pop(L) = B;
        
    end
    
end