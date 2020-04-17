function F=randomfrog_plslda(X,Y,A,method,N,Q,prior)
%+++ Random Frog for variable selection for high dimensional data.
%+++ Input:  X: m x n  (Sample matrix)
%            Y: m x 1  (measured property)
%            A: The maximal number of latent variables for
%               cross-validation
%       method: data pretreat method,'center' or 'autoscaling'
%            N: The number of Simulation.
%            Q: Intial number of variables to sample
%       prior: prior probability of positive class. Default to 0 for computing prior from data..say ldapinv.m f    or details
%+++ Output: Structural data: F
%+++ Supervisor: Yizeng Liang, yizeng_liang@263.net
%+++ Edited by H.D. Li,Aug. 13, 2011, lhdcsu@gmail.com

if nargin<7;prior=0;end
if nargin<6;Q=2;end
if nargin<5;N=10000;end
if nargin<4;method='autoscaling';end
if nargin<3;A=10;end


tic;
%+++ basic parameters of data input
if Q<2;Q=2;end
[n,p]=size(X);
Q0=Q;
varIndex=1:p;

%+++ randomly initialize a subset of variables: V0.随机初始化变量子集：V0。
perm=randperm(p);
V0=perm(1:Q);


%+++ Main loop for Random Frog随机青蛙的主循环
probability=zeros(1,p);
for i=1:N
  nVstar=min(p,max([round(randn(1)*0.3*Q+Q) 2]));
  
  PLSLDA=plslda(X(:,V0),Y,A,method,prior);
  B=abs(PLSLDA.regcoef_lda_origin(1:end-1));
 
  Vstar=generateNewModel(V0,nVstar,B,varIndex,X,Y,A,method,prior);    %+++ define a function
  CV0=plsldacv(X(:,V0),Y,A,3,method,prior,0);
  ARMSEP0=CV0.error_min;
  CVstar=plsldacv(X(:,Vstar),Y,A,3,method,prior,0);
  ARMSEPstar=CVstar.error_min;
  
  if ARMSEPstar<ARMSEP0
      probAccept=1;
  else
      probAccept=0.1*(ARMSEP0+0.001)/(ARMSEPstar+0.001);
  end
%   probAccept=min(length(V0)*ARMSEP0/ARMSEPstar/nVstar,1);
  randJudge=rand(1);
  if probAccept>randJudge
    V0=Vstar;RMSEP(i)=ARMSEPstar;nVar(i)=nVstar;
  else
    V0=V0;RMSEP(i)=ARMSEP0;nVar(i)=Q;
  end
  probability(V0)=probability(V0)+1;
  Q=length(V0);
  if mod(i,100)==0;fprintf('The %dth sampling for random frog finished.\n',i);end
end
probability=probability/N;
[sorted,Vrank]=sort(-probability);
Vtop10=Vrank(1:10);
toc;
%+++ Output
F.N=N;
F.Q=Q0;
F.minutes=toc/60;
F.method=method;
F.Vrank=Vrank;
F.Vtop10=Vtop10; % the top-10 ranked vairables.
F.probability=probability;
F.nVar=nVar;
F.RMSEP=RMSEP;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++%%%%%%%%%%  subfunctions  %%%%%%%%%%%%%
function Vstar=generateNewModel(V0,nV1,B,varIndex,X,Y,A,method,prior)
nV0=length(V0);
d=nV1-nV0;
if d>0
  varIndex(V0)=[];
  kvar=length(varIndex);
  perm=randperm(kvar);
  perm=perm(1:min(3*d,kvar));
  Vstartemp=[V0 varIndex(perm)];
  PLSLDA=plslda(X(:,Vstartemp),Y,A,method,prior);
  B=abs(PLSLDA.regcoef_lda_origin(1:end-1));
  [sorted,index]=sort(-B);  
  Vstar=Vstartemp(index(1:nV1));  
elseif d<0
  [sorted,index]=sort(-B);  
  Vstar=V0(index(1:nV1));
else
  Vstar=V0;
end

