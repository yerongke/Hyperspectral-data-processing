function chain = projection(X,k,M)

% Projections routine for the Successive Projections Algorithm using the
% built-in QR function of Matlab
%
% chain = projections(X,k,M)
%
% X --> Matrix of predictor variables (# objects N x # variables K) 预测变量矩阵（对象n x变量k）
% k --> Index of the initial column for the projection operations  投影操作的初始列索引
% M --> Number of variables to include in the chain              链中要包含的变量数
%
% chain --> Index set of the variables resulting from the projection
% operations 投影操作产生的变量的索引集

X_projected = X;

norms = sum(X_projected.^2);    % Square norm of each column vector 每列向量的平方范数
norm_max = max(norms); % Norm of the "largest" column vector “最大”列向量的范数

X_projected(:,k) = X_projected(:,k)*2*norm_max/norms(k); % Scales the kth column so that it becomes the "largest" column缩放第k列，使其成为“最大”列

[dummy1,dummy2,order] = qr(X_projected,0); %qr函数是正交分解
chain = order(1:M)';