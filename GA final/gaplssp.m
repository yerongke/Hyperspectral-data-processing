% Application of GA to the selection of the "best" subset
% for a PLS regression, especially suited for spectral data.
%
% by R. Leardi
%
% Dipartimento di Chimica e Tecnologie Farmaceutiche ed Alimentari
% via Brigata Salerno (ponte) - 16147 GENOVA (ITALY)
% e-mail: riclea@dictfa.unige.it
%
% The syntax is: [b,fin,sel]=gaplssp(dataset,evaluat,precision)
% where b=vector of the variables in decreasing order of selection
%       fin=matrix with the results of the final stepwise:
%           row 1 = # of variables used
%           row 2 = response (% C. V.)
%           row 3 = # of components
%           row 4 = RMSECV
%	sel=vector with the frequency of selection
%
% The y variable is the last one
%
% 3 input parameters have to be specified:
% 1) data set
% 2) number of evaluations per run
% 3) the precision of the analytical method (optional)

function [b,fin,sel]=gaplssp(dataset,evaluat,~)
clc
format compact
randomiz
if nargin==2
  precision=0;
end
[o,c]=size(dataset);
disp(['objects: ' int2str(o)])
y=dataset(:,c);
v=c-1;
disp(['variables: ' int2str(v)]);
s1=[];s2=[];b=[];fin=[];sel=[];sels=[];

aut=2; % autoscaling; 0=raw data; 1=column centering  自动缩放；0=原始数据；1=列居中
ng=5; % 5 deletion groups  5个删除组
cr=30; % 30 chromosomes 30条染色体
nvar=5; % on average 5 variables per chromosome in the orig. pop.在原始染色体中平均每个染色体有5个变量。父代。
probsel=ones(1,v)*nvar/v;
maxvar=30; % 30 variables as a maximum  30个变量作为最大值
probmut=0.001; % probability of mutation 1%变异概率
probcross=0.5; % probability of cross-over 50%交叉概率
freqb=100; % backward stepwise every 100 evaluations 
if floor(evaluat/100)==evaluat/100;
  endb='N';
else
  endb='Y';
end
runs=100; % 100 runs
el=3;

% computation of CV var. with all the variables
% (the optimal number of components will be the maximum for GA) 所有变量的变异系数计算（组件的最佳数量将是GA的最大值）
[maxcomp,start,mxi,sxi,myi,syi]=plsgacv(dataset(:,1:v),y,aut,ng,15);
disp(' ')
disp(['With all the variables:'])
disp(['components: ' int2str(maxcomp)])
disp(['C.V. variance: ' num2str(start)])

sel=zeros(1,v); % sel stores the frequency of selection sel存储选择的频率
probsels=sel;
probselsw=sel;
probself=sel;
for r=1:runs
  sel=[sel 0];
  disp(' ')
  disp(['run ' num2str(r)])
  % creation and evaluation of the starting population 初始人口的创造与评价
  crom=zeros(cr,v);
  resp=zeros(cr,1);
  comp=zeros(cr,1);
  p=zeros(2,v);
  numvar=zeros(cr,1); %%% numvar stores the number of variables in each chr. numvar存储每个chr中的变量数。
  lib=[]; %%% lib is the matrix with all the already tested chromosomes %%%lib是所有已经检测过的染色体的母体
  libb=[];%%% libb is the matrix with all the already backw. chromosomes %%%libb是所有已经有backw的矩阵。染色体
  nextb=freqb;
  cc=0;
  probself=probsel;
  if r>1
   probsels=sel(1:v)/sum(sel)*nvar;
   probselsw(1)=(probsels(1)+probsels(2))/2;
   probselsw(v)=(probsels(v)+probsels(v-1))/2;
   for jj=2:v-1
     probselsw(jj)=(probsels(jj-1)+probsels(jj)+probsels(jj+1))/3;
   end
   % probselsw obtained as moving average (window size 3) of probsels 作为探针的移动平均值（窗口大小3）获得的探针
   probself=(probsel*(runs-r+1)+probselsw*(r-1))/runs;
         disp([num2str(min(probself)) ' - ' num2str(max(probself))])
  end
  while cc<cr
    den=0;
    sumvar=0;
    while (sumvar==0 || sumvar>maxvar)
      a=rand(1,v);
      for j=1:v
        if a(1,j)<probself(1,j)
          a(1,j)=1;
        else
          a(1,j)=0;
        end    
      end
      sumvar=sum(a);
    end
    den=checktw(cc,lib,a);
    if den==0
      lib=[lib;a];
      if cc>0
        [s1,s2]=CHKSUBS(cc,crom(1:cc,:),a);
      end
      cc=cc+1;  
      var=find(a);
      [fac,risp]=plsgacv(dataset(:,var),y,aut,ng,maxcomp,mxi(:,var),sxi(:,var),myi,syi);
      if isempty(s2)
        mm=0;
      else
        mm=max(resp(s2));
      end
      if risp>mm  % the new chrom. survives only if better
        crom(cc,:)=a;
        resp(cc,1)=risp;
        comp(cc,1)=fac;
        numvar(cc,1)=size(var,2);
        for kk=1:size(s1,2)
          if risp>=resp(s1(kk))
            resp(s1(kk))=0; % the old chrom. are killed if worse
          end
        end
      end
    end
  end

  [vv,pp]=sort(resp);
  pp=flipud(pp);
  crom=crom(pp,:);
  resp=resp(pp,:);
  comp=comp(pp,:);
  numvar=numvar(pp,:);

  disp(' ')
  disp(['After the creation of the original population: ' num2str(resp(1))])
  maxrisp=resp(1);

  while cc<evaluat
    % selection of 2 chromosomes 2条染色体的选择
    cumrisp=cumsum(resp);
    if resp(2)==0
      rr=randperm(cr);
      p(1,:)=crom(rr(1),:);
      if resp(1)==0
        p(2,:)=crom(rr(2),:);
      else
        p(2,:)=crom(1,:);
      end
    else
      k=rand*cumrisp(cr);
      j=1;
      while k>cumrisp(j)
        j=j+1;
      end
      p(1,:)=crom(j,:);
      p(2,:)=p(1,:);
      while p(2,:)==p(1,:)
        k=rand*cumrisp(cr);
        j=1;
        while k>cumrisp(j)
          j=j+1;
        end
        p(2,:)=crom(j,:);
      end
    end
 
    % cross-over between the 2 chromosomes 两条染色体交叉
    s=p;
    diff=find(p(1,:)~=p(2,:));
    randmat=rand(1,size(diff,2));
    cro=find(randmat<probcross);
    s(1,diff(cro))=p(2,diff(cro));
    s(2,diff(cro))=p(1,diff(cro));

    % mutations 突变
    m=rand(2,v);
    for i=1:2
      f=find((m(i,:))<probmut);
      bb=size(f,2);
      for j=1:bb
        if s(i,f(j))==0
          s(i,f(j))=1;
        else
          s(i,f(j))=0;
        end
      end
    end
 
    % evaluation of the offspring 子代评价
    for i=1:2
      den=0;
      var=find(s(i,:));
      sumvar=sum(s(i,:));
      if sumvar==0 || sumvar>maxvar
        den=1;
      end
      if den==0
        den=checktw(cc,lib,s(i,:));
      end
      if den==0
        cc=cc+1;  
    	  [fac,risp]=plsgacv(dataset(:,var),y,aut,ng,maxcomp,mxi(:,var),sxi(:,var),myi,syi);
        lib=[s(i,:);lib];
        if risp>maxrisp
          disp(['ev. ' int2str(cc) ' - ' num2str(risp)])
          maxrisp=risp;
        end
        if risp>resp(cr)
          [crom,resp,comp,numvar]=Update(cr,crom,s(i,:),resp,comp,numvar,risp,fac,var);
        end
      end
    end

    % stepwise 逐步
    if cc>=nextb
      nextb=nextb+freqb;
      [nc,rispmax,compmax,cc,maxrisp,libb]=backw(r,cr,crom,resp,numvar,cc,dataset,y,aut,ng,maxcomp,maxrisp,libb,mxi,sxi,myi,syi,el);
      if isempty(nc)~=1
	[crom,resp,comp,numvar]=Update(cr,crom,nc,resp,comp,numvar,rispmax,compmax,find(nc));
      end
    end

  end

  if endb=='Y' % final stepwise 最后一步
    [nc,rispmax,compmax,cc,maxrisp,libb]=backw(r,cr,crom,resp,numvar,cc,dataset,y,aut,ng,maxcomp,maxrisp,libb,mxi,sxi,myi,syi,el);
    if isempty(nc)~=1
	[crom,resp,comp,numvar]=Update(cr,crom,nc,resp,comp,numvar,rispmax,compmax,find(nc));
    end
  end

  sel=sel(1:v)+crom(1,:);
  disp(find(crom(1,:)))
  figure(1)
  bar(sel);
  set(gca,'XLim',[0 v])
  title(['Frequency of selections after ' int2str(r) ' runs']); 
  drawnow

end

sels=zeros(1,v);
sels(1)=(sel(1)+sels(2))/2;
sels(v)=(sel(v)+sels(v-1))/2;
for jj=2:v-1
  sels(jj)=(sel(jj-1)+sel(jj)+sel(jj+1))/3;
end
sel=sels;

[a,b]=sort(-sel);
sel=-a;

disp([' '])
disp('Stepwise according to the smoothed frequency of selection');
fin=[];
k=v-1;
if v-1>200
  k=200;
end
for c=1:k
  if sel(c)>sel(c+1)
    [fac,risp]=plsgacv(dataset(:,b(1:c)),y,aut,ng,maxcomp,mxi(:,b(1:c)),sxi(:,b(1:c)),myi,syi);
    sep=sqrt(1-risp/100)*syi(ng+1);sep=sep-sep/(2*o-2);
    fin=[fin [c;risp;fac;sep]];
    disp(' ')
    disp(['With ' int2str(c) ' var. ' num2str(risp) ' (' int2str(fac) ' comp.)'])
  end
end
plotone(dataset,b,fin,sel);
