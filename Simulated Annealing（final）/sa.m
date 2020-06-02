
clc;
clear;
close all;

%% Problem Definition

data=LoadData();

nf=15;   % Desired Number of Selected Features

CostFunction=@(q) FeatureSelectionCost(q,nf,data);    % Cost Function

%% SA Parameters

MaxIt=50;     % Maximum Number of Iterations最大迭代次数  外层循，主要更新参数t，模拟退火过程

MaxSubIt=12;    % Maximum Number of Sub-iterations最大子迭代数   内层循环，寻找在一定温度下的最优值

T0=195;         % Initial Temp.初始温度

alpha=0.99;     % Temp. Reduction Rate温度 减少率

%% Initialization

% Create and Evaluate Initial Solution创建和评估初始解决方案
sol.Position=CreateRandomSolution(data);
[sol.Cost, sol.Out]=CostFunction(sol.Position);%CostFunction为代价函数

% Initialize Best Solution Ever Found初始化有史以来最好的解决方案
BestSol=sol;

% Array to Hold Best Cost Values保持最佳值的阵列
BestCost=zeros(MaxIt,1);

% Intialize Temp.初始温度
T=T0;

%% SA Main Loop

for it=1:MaxIt
    
    for subit=1:MaxSubIt
        
        % Create and Evaluate New Solution创建和评估新解决方案
        newsol.Position=CreateNeighbor(sol.Position);
        [newsol.Cost, newsol.Out]=CostFunction(newsol.Position);
        
        if newsol.Cost<=sol.Cost % If NEWSOL is better than SOL
            sol=newsol;
            
        else % If NEWSOL is NOT better than SOL
            
            DELTA=(newsol.Cost-sol.Cost)/sol.Cost;
            
            P=exp(-DELTA/T);%Metropolis准则
            if rand<=P
                sol=newsol;
            end
            
        end
        
        % Update Best Solution Ever Found更新有史以来最好的解决方案
        if sol.Cost<=BestSol.Cost
            BestSol=sol;
        end
    
    end
    
    % Store Best Cost Ever Found存储有史以来最好的成本
    BestCost(it)=BestSol.Cost;
    
    % Display Iteration Information显示迭代信息
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Update Temp.跟新温度
    T=alpha*T;
        
end

%% Results
pp=1:1:50;
pp=pp';
figure;
%plot(BestCost,'LineWidth',2);
%plot(BestCost,'b-o');
plot(pp,BestCost,'--  gs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5])
xlabel('Iteration');
ylabel('Best Cost');
