function [P,Q,W,T,U,bsco,ssqdif] = pls(X,Y,lv)

%  pls calculates a PLS model
%
%  Input:
%  X: independent variables
%  Y: dependent variable(s)
%  lv: number of latent variables
%
%  [P,Q,W,T,U,bsco,ssqdif] = pls(X,Y,lv);

[nX,mX] = size(X);
[nY,mY] = size(Y);
if mX < lv
  error('The number of X variables is lower than the selected number of components')
end
if nX ~= nY
  error('The number of X samples does not match the number of Y ditto')
end

P = zeros(mX,lv);
Q = zeros(mY,lv);
W = zeros(mX,lv);
T = zeros(nX,lv);
U = zeros(nY,lv);
bsco = zeros(1,lv);
ssq = zeros(lv,2);
ssqX = sum(sum(X.^2));
ssqY = sum(sum(Y.^2));
for i = 1:lv
  [p,q,w,t,u] = plsonecomp(X,Y);  % Subfunction in this file
  bsco(:,i) = u'*t/(t'*t);
  X = X - t*p';
  Y = Y - bsco(:,i)*t*q';
  ssq(i,1) = sum(sum(X.^2))*100/ssqX;
  ssq(i,2) = sum(sum(Y.^2))*100/ssqY;
  T(:,i) = t(:,1);
  U(:,i) = u(:,1);
  P(:,i) = p(:,1);
  W(:,i) = w(:,1);
  Q(:,i) = q(:,1);
end
ssqdif = zeros(lv,2);
ssqdif(1,1) = 100 - ssq(1,1);
ssqdif(1,2) = 100 - ssq(1,2);
for i = 2:lv
  for j = 1:2
    ssqdif(i,j) = -ssq(i,j) + ssq(i-1,j);
  end
end

function [p,q,w,t,u] = plsonecomp(X,Y)

[ny,my] = size(Y);
if my == 1
  u = Y(:,1);
else
  SumSquaresY = sum(Y.^2);
  [ymax,yi] = max(SumSquaresY);
  u = Y(:,yi);
end
t_difference = 100;
t_old = X(:,1);
it_count = 1;
%  Conversion limit: 1e-10
while t_difference > 1e-10
  it_count = it_count + 1;
  w = (u'*X)';
  w = (w'/norm(w'))';
  t = X*w;
  if my == 1
    q = 1;
    break
  end
  q = (t'*Y)';
  q = (q'/norm(q'))';
  u = Y*q;
  t_difference = norm(t_old - t);
  t_old = t;
  if it_count >= 1000
    disp('No convergence up to 1000 iterations')
    break;
  end
end
p = (t'*X/(t'*t))';
p_norm=norm(p);
t = t*p_norm;
w = w*p_norm;
p = p/p_norm;
