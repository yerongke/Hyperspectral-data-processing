function F=irf(X,y,N,w,Q,A,method)
%%%%%% interval random frog (IRF) for wavelength interval selection method %%%%%%
%+++ X: The data matrix of size m x p
%+++ y: The reponse vector of size m x 1
%+++ N: the number of iterations
%+++ w: the fixed window size to move over the whole spectra
%+++ Q: the initialized number of sub-intervasl.
%+++ A: the maximal principle component.
%+++ method: pretreatment method.
%+++ Yonghuan Yun, Nov. 05. 2012, yunyonghuan@foxmail.com  
%+++ Reference: An efficient method of wavelength interval selection based on random frog 
%    for multivariate spectral calibration,Spectrochimica Acta Part A
%    Volume 111, July 2013, Pages 31¨C36
%+++ Based on random frog proposed by Hongdong Li,lhdcsu@gmail.com
%+++ Advisor: Yizeng Liang, yizeng_liang@263.net
%+++ Random Frog article: H.-D. Li, Q.-S. Xu, Y.-Z. Liang, Ana. Chim. Acta, 740 (2012) 20-26.

if nargin<7;method='center';end
if nargin<6;A=10;end
if nargin<5;Q=20;end
if nargin<4;w=10;end
if nargin<3;N=1000;end

tic;
[Mx,Nx]=size(X);
k=1;
%+++ obtain all the possible intervals 
for j=1:Nx-w+1
    intervals{1,k}=j:j+w-1;
    k=k+1;     
end   
 p=length(intervals);
 varIndex=1:p; 
 Q0=Q;
 %+++ Initialize a subset of intervals: V0.     
 perm=randperm(p);     
 V0=perm(1:Q);   
 %+++ Main loop for iRF   
 probability=zeros(1,p);
for i=1:N
  nVstar=min(p,max([round(randn(1)*0.3*Q+Q) 2]));
  if length(V0)==1
      U0=intervals{V0};
  end
  if length(V0)>=2
      U0=intervals{V0(1)};
      for iii=2:length(V0)
          %+++ the union of the intervals
          U0=union(U0,intervals{V0(iii)});
      end
  end
  PLS=pls(X(:,U0),y,A,method);    
  B=abs(PLS.regcoef_original(1:end-1,end));
  clear Binterval;
  for ii=1:length(V0)
  [C,IA,IB] = intersect(U0,intervals{1,V0(ii)});
  %+++ sum of absoulte regression coefficient   
  Binterval(ii)=sum(B(IA));
  end
  nV1=nVstar;
  %+++ define a function
  Vstar=generateNewModel(V0,nV1,Binterval,varIndex,intervals,X,y,A,method); 
  if length(V0)==1
      U0=intervals{V0};
  end
  if length(V0)>=2
      U0=intervals{V0(1)};
      for iii=2:length(V0)
          U0=union(U0,intervals{V0(iii)});
      end
  end
  CV0=plscv(X(:,U0),y,A,10,method,0);
  ARMSEP0=CV0.RMSECV_min;
  if length(Vstar)>=2
      Ustar=intervals{Vstar(1)};
      for iii=2:length(Vstar)
          Ustar=union(Ustar,intervals{Vstar(iii)});
      end
  end
  CVstar=plscv(X(:,Ustar),y,A,10,method,0);
  ARMSEPstar=CVstar.RMSECV_min;
  
  if ARMSEPstar<ARMSEP0
      probAccept=1;
  else
      probAccept=0.1*ARMSEP0/ARMSEPstar;
  end
  randJudge=rand(1);
  if probAccept>randJudge
    V0=Vstar;RMSEP(i)=ARMSEPstar;nIntervals(i)=nVstar;
  else
    V0=V0;RMSEP(i)=ARMSEP0;nIntervals(i)=Q;
  end
  probability(V0)=probability(V0)+1;
  Q=length(V0);
  if mod(i,100)==0;fprintf('The %dth sampling of iRF has finished.\n',i);end
end
probability=probability/N;
[sorted,Intervalsrank]=sort(-probability);
top10=Intervalsrank(1:10);


for j=1: size(intervals,2)    
    Utemp=intervals{Intervalsrank(1)};      
    for iii=1:j        
        Utemp=union(Utemp,intervals{Intervalsrank(iii)});      
    end     
    vsel_temp{1,j}=Utemp;   
    X1=X(:,Utemp); 
    CV=plscv(X1,y,A,10,'center',0);
    RMSECV(j)=CV.RMSECV_min;
    fprintf('The %dth of %d circle finished.\n',j,size(intervals,2)) 

end

% choose the intervals with the lowest RMSECV
[RMSECV_min,index]=min(RMSECV);
% the union of selected intervals 
vsel=vsel_temp{index};
toc;
%+++ Output
F.intervals=intervals;
F.N=N;
F.Q=Q0;
F.minutes=toc/60;
F.method=method;
F.Intervalsrank=Intervalsrank;% all the ranked intervals.
F.vsel=vsel;  % selected variables
F.top10=top10;
F.probability=probability;
F.nIntervals=nIntervals;
F.RMSEP=RMSEP;  
F.RMSECV=RMSECV;
F.RMSECV_min=RMSECV_min;

     
     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%+++%%%%%%%%%%  subfunctions  %%%%%%%%%%%%%
function Vstar=generateNewModel(V0,nV1,Binterval,varIndex,intervals,X,y,A,method)
nV0=length(V0);
d=nV1-nV0;
if d>0
   
  varIndex(V0)=[];
  kvar=length(varIndex);
  perm=randperm(kvar);
  perm=perm(1:min(3*d,kvar));
  clear Vstartemp;
  Vstartemp=[V0 varIndex(perm)];
  if length(Vstartemp)==1
      Ustar=intervals{Vstartemp};
  end
   if length(Vstartemp)>=2
      Ustar=intervals{Vstartemp(1)};
      for iii=2:length(Vstartemp)
          Ustar=union(Ustar,intervals{Vstartemp(iii)});
      end
  end
  PLS=pls(X(:,Ustar),y,A,method);
     B=abs(PLS.regcoef_original(1:end-1,end));
  clear Binterval_star;
  for ii=1:length(Vstartemp)
  [C,IA,IB]=intersect(Ustar,intervals{1,Vstartemp(ii)});
  Binterval_star(ii)=sum(B(IA))/length(B(IA));
  end
  clear index;
  [sorted,index]=sort(-Binterval_star);
  Vstar=Vstartemp(index(1:nV1));
end
if d<0
   clear index;
  [sorted,index]=sort(-Binterval);  
  Vstar=V0(index(1:nV1));
end
 if d==0;
  Vstar=V0;
 end





