function Ypred = pls_pre(Xpred,bsco,P,Q,W,lv)

%  pls_pre makes a prediction with a PLS model and stores predictions for all latent variables
%
%  Input: From pls file
%  Output: A three-dimensional array
%
%  Ypred = pls_pre(Xpred,bsco,P,Q,W,lv);

[nX,mX] = size(Xpred);
[nQ,mQ] = size(Q);
t_hat = zeros(nX,lv);
Ypred = zeros(nX,nQ,lv);
for i = 1:lv
  t_hat(:,i) = Xpred*W(:,i);
  Xpred = Xpred - t_hat(:,i)*P(:,i)';
end
temp=0;
for i = 1:lv
  temp=temp+bsco(1,i)*t_hat(:,i)*Q(:,i)';
  Ypred(:,:,i)=temp; 
end
