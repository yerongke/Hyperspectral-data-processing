function [m,dminmax] = spxy(X,Y,N)

% Algorithm for Sample set Partitioning based on joint X-Y distances
% [m,dminmax] = spxy(X,Y,N);
%
% X --> Matrix of instrumental responses
% Y --> Matrix of parameters
% N --> Number of samples to be selected (minimum of 2)
%
% m --> Indexes of the selected samples
%
% dminmax(1) = 0;
% dminmax(2) = Joint XY distance between the two first samples selected by the algorithm
% dminmax(i) = Smallest joint XY distance between the i-th selected sample and the previously selected ones (i > 2)
%
% Reference:
% R. K. H. Galvao, M. C. U. Araujo, G. E. Jose, M. J. C. Pontes, E. C. Silva, T. C. B. Saldanha
% A method for calibration and validation subset partitioning
% Talanta, vol. 67, pp. 736-740, 2005.
%
% Web site: www.ele.ita.br/~kawakami/spa/

dminmax = zeros(1,N); % Initializes the vector of minimum distances
M = size(X,1); % Number of rows in X (samples)
samples = 1:M;

% Auto-scales the Y matrix
for i=1:size(Y,2) % For each parameter in Y
    yi = Y(:,i);
    Y(:,i) = (yi - mean(yi))/std(yi);
end

D = zeros(M,M); % Initializes the matrix of X distances
Dy = zeros(M,M); % Initializes the matrix of Y distances

for i=1:M-1
    xa = X(i,:);
    ya = Y(i,:);
    for j = i+1:M
      xb = X(j,:);
      yb = Y(j,:);
      D(i,j) = norm(xa - xb);
      Dy(i,j) =  norm(ya - yb);
    end
end

Dmax = max(max(D));
Dymax = max(max(Dy));

D = D/Dmax + Dy/Dymax; % Combines the distances in X and Y

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
    
