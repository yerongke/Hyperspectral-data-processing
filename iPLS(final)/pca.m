function PCAmodel = pca(X,no_of_lv,prepro_method);

%  pca for iPCA modelling
%
%  Input:
%  X contains the independent variables
%  no_of_lv is the number of PCA components
%  prepro_method is 'mean', 'auto', 'mscmean', 'mscauto' or 'none'
%
%  Output:
%  PCAmodel is a structured array containing all model and validation information
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  PCAmodel = pca(X,no_of_lv,prepro_method);

[n,m] = size(X);

if strcmp(lower(prepro_method),'mean')
   [X,mx]=mncn(X);
elseif strcmp(lower(prepro_method),'auto')
   [X,mx,stdx]=auto(X);
elseif strcmp(lower(prepro_method),'mscmean')
   [X,Xsegmeancal]=msc(X);
   [X,mx]=mncn(X);
elseif strcmp(lower(prepro_method),'mscauto')
   [X,Xsegmeancal]=msc(X);
   [X,mx,stdx]=auto(X);
elseif strcmp(lower(prepro_method),'none')
   % To secure that no centering/scaling is OK    
end

[PCAmodel.T,PCAmodel.P,PCAmodel.varexp]=subpca(X,no_of_lv);

% Subfunctions mncn, auto, msc, subpca
function [Xmean,meanX] = mncn(X)
[n,m] = size(X);
meanX = mean(X);
Xmean = (X-meanX(ones(n,1),:));

function [Xauto,meanX,stdX] = auto(X)
[n,m] = size(X);
meanX = mean(X);
stdX  = std(X);
Xauto = (X-meanX(ones(n,1),:))./stdX(ones(n,1),:);

function [Xmsc,Xmeancal]=msc(X)
[n,m]=size(X);
Xmeancal=mean(X);
for i=1:n
  coef=polyfit(Xmeancal,X(i,:),1);
  Xmsc(i,:)=(X(i,:)-coef(2))/coef(1);
end

function [T,P,varexp] = subpca(X,no_of_lv)
%  Principal component analysis by SVD
[n,m] = size(X);
if m < n
  cov = (X'*X);
  [u,s,v] = svd(cov);
  PCnumber = (1:m)';
else
  cov = (X*X');
  [u,s,v] = svd(cov);
  v = X'*v;
  for i = 1:n
    v(:,i) = v(:,i)/norm(v(:,i));
  end
  PCnumber = (1:n)';
end
individualExpVar = diag(s)*100/(sum(diag(s)));
varexp  = [PCnumber individualExpVar cumsum(individualExpVar)];
P  = v(:,1:no_of_lv);
T = X*P;
