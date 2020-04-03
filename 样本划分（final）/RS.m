%%即随机选取一定数量的样本组成训练集。这种选取完全是随意的没有规律的或者遵循简单的规则。
%%训练集组成方法简单，不需要进行数据挑选，但每次组成训练集的样本可能差异很大，不能保证所选样本代表性及模型的外推能力。
function m = RS(X,N)

% Random Sampling Algorithm for selection of samples
% m = rs(X,N);
%
% X --> Matrix of instrumental responses
% N --> Number of samples to be selected 
%
% m --> Indexes of the selected samples

M = size(X,1); % Number of rows in X (samples)

rand_samples = randperm(M);

m = rand_samples(1:N);
