%把所有的样本都看作训练集候选样本，依次从中挑选样本进训练集，首先选择欧氏距离最远的两个向量对进入训练集，在接下来的迭代过程中拥有最大最小距离的待选样本
%被选入训练库．以此类推，达到所要求的样本数目。
%该方法优点是能保证训练库中样本按照空间距离分布均匀。缺点是需要进行数据转换和计算样本两两空间距离，计算量大。

function [m,dminmax] = KS(X,N)

% Kennard-Stone Algorithm for selection of samples
% [m,dminmax] = ks(X,N);
%
% X --> Matrix of instrumental responses
% N --> Number of samples to be selected (minimum of 2)
%
% m --> Indexes of the selected samples
%
% dminmax(1) = 0;
% dminmax(2) = Euclidean distance between the two first samples selected by the algorithm
% dminmax(i) = Smallest distance between the i-th selected sample and the previously selected ones (i > 2)

dminmax = zeros(1,N); % Initializes the vector of minimum distances 
M = size(X,1); % Number of rows in X (samples)
samples = 1:M;

D = zeros(M,M); % Initializes the matrix of distances
for i=1:M-1
    xa = X(i,:);
    for j = i+1:M
      xb = X(j,:);
      D(i,j) = norm(xa - xb);
    end
end

% D: Upper Triangular Matrix
% D(i,j) = Euclidean distance between objects i and j (j > i)

[maxD,index_row] = max(D); % maxD = Row vector containing the largest element of each column in D
                             % index_row(n) = Index of the row with the largest element in the n-th column

[dummy,index_column] = max(maxD); % index_column = column corresponding to the largest element in matrix D

m(1) = index_row(index_column);
m(2) = index_column;

dminmax(2) = D(m(1),m(2));

for i = 3:N
    % This routine determines the distances between each sample still available for selection and each of the samples already selected
    pool = setdiff(samples,m); % pool = Samples still available for selection
    dmin = zeros(1,M-i+1); % Initializes the vector of minimum distances between each sample in pool and the samples already selected
    for j = 1:(M-i+1) % For each sample xa still available for selection
        indexa = pool(j); % indexa = index of the j-th sample in pool (still available for selection)
        d = zeros(1,i-1); % Initializes the vector of distances between the j-th sample in pool and the samples already selected
        for k = 1:(i-1) % The distance with respect to each sample already selected is analyzed
            indexb =  m(k); % indexb = index of the k-th sample already selected
            if indexa < indexb
                d(k) = D(indexa,indexb);
            else
                d(k) = D(indexb,indexa);
            end
        end
        dmin(j) = min(d);
    end
    % The selected sample corresponds to the largest dmin
    [dminmax(i),index] = max(dmin);
    m(i) = pool(index);
end
