% Application of GA to the selection of the "best" subset
% for a PLS regression.
%
% by R. Leardi
%
% Dipartimento di Chimica e Tecnologie Farmaceutiche ed Alimentari
% via Brigata Salerno (ponte) - 16147 GENOVA (ITALY)
% e-mail: riclea@dictfa.unige.it
%
% The syntax is: [progr]=gaplsopt(dataset,el)
% where progr=matrix of the progress of the GA in the different runs
%
% The y variable is the last one
%
% This version has no interactive input, and therefore repeated series
% of runs can be performed.
% 2 input parameters have to be specified:
% 1) data set
% 2) type of elaboration (1=random. test, 2=optimization)

function [progr]=gaplsopt(dataset,el) %,nvar,evaluat,freqb,endb,runs)
clc
format compact
randomiz
[o,c]=size(dataset);
disp(['objects: ' int2str(o)])
y=dataset(:,c);
v=c-1;
disp(['variables: ' int2str(v)]);
s1=[];s2=[];progr=[];sel=[];

aut=2; % autoscaling; 0=raw data; 1=column centering
ng=5; % 5 deletion groups
cr=30; % 30 chromosomes
probsel=5/v; % on average 5 variables per chromosome in the orig. pop.在原始染色体中平均每个染色体有5个变量。父代。
maxvar=30; % 30 variables as a maximum
probmut=0.001; % probability of mutation 0.1%变异概率0.1%
probcross=0.5; % probability of cross-over 50%
if el==1
  runs=50;
  evaluat=100;
else
  runs=40;
  evaluat=200;
end

% computation of CV var. with all the variables
% (the optimal number of components will be the maximum for GA)
[maxcomp,start,mxi,sxi,myi,syi]=plsgacv(dataset(:,1:v),y,aut,ng,15);
disp(' ')
disp(['With all the variables:'])
disp(['components: ' int2str(maxcomp)])
disp(['C.V. variance: ' num2str(start)])

for r=1:runs
  sel=[sel 0];
  disp(' ')
  disp(['run ' num2str(r)])
  % creation and evaluation of the starting population
  crom=zeros(cr,v);
  resp=zeros(cr,1);
  comp=zeros(cr,1);
  p=zeros(2,v);
  numvar=zeros(cr,1); %%% numvar stores the number of variables in each chr.
  lib=[]; %%% lib is the matrix with all the already tested chromosomes %%%
  libb=[];%%% libb is the matrix with all the already backw. chromosomes %%%
  cc=0;
  if el==1 || (el==2 && r>runs/2)
    k=randperm(o);
    y=y(k);
  end
  while cc<cr
    den=0;
    sumvar=0;
    while (sumvar==0 || sumvar>maxvar)
      a=rand(1,v);
      for j=1:v
        if a(1,j)<probsel
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
      [fac,risp]=plsgacv(dataset(:,var),y,aut,ng,maxcomp,mxi(:,var),sxi(:,var));
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

  progr(r,cc-cr+1)=resp(1);
  disp(' ')
  disp(['After the creation of the original population: ' num2str(resp(1))])
  maxrisp=resp(1);

  while cc<evaluat
    % selection of 2 chromosomes
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

    % cross-over between the 2 chromosomes
    s=p;
    diff=find(p(1,:)~=p(2,:));
    randmat=rand(1,size(diff,2));
    cro=find(randmat<probcross);
    s(1,diff(cro))=p(2,diff(cro));
    s(2,diff(cro))=p(1,diff(cro));

    % mutations
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
 
    % evaluation of the offspring
    for i=1:2
      den=0;
      var=find(s(i,:));
      sumvar=sum(s(i,:));
      if sumvar==0 | sumvar>maxvar
        den=1;
      end
      if den==0
        den=checktw(cc,lib,s(i,:));
      end
      if den==0
        cc=cc+1;  
     	[fac,risp]=plsgacv(dataset(:,var),y,aut,ng,maxcomp,mxi(:,var),sxi(:,var));
        lib=[s(i,:);lib];
        if risp>maxrisp
          disp(['ev. ' int2str(cc) ' - ' num2str(risp)])
          maxrisp=risp;
        end
        if risp>resp(cr)
          [crom,resp,comp,numvar]=Update(cr,crom,s(i,:),resp,comp,numvar,risp,fac,var);
        end
      end
      progr(r,cc-cr+1)=resp(1);
    end
  end
end

pp=[cr:evaluat];
progr=progr(:,1:evaluat-cr+1);
if el==1
  figure(1)
  plot(pp,progr','y')
  hold on
  plot(pp,mean(progr), 'r')
  hold off
  title(['Randomization test']);
  figure(gcf)
  disp(' ')
  disp(['Result of the randomization test: ' num2str(mean(progr(:,evaluat-cr+1)))]);
end

if el==2
  figure(1)
  plot(pp,progr(1:runs/2,:)', 'y')
  hold on
  plot(pp,progr(runs/2+1:runs,:)', 'r')
  mpos=mean(progr(1:runs/2,:));
  plot(pp,mpos, 'g')
  mneg=mean(progr(runs/2+1:runs,:));
  plot(pp,mneg, 'c')
  diffmeans=mpos-mneg;
  plot(pp,diffmeans, 'w')
  hold off
  title(['Optimization']);
  figure(gcf)
  [k,j]=max(diffmeans);
  disp(' ')
  disp(['Maximum difference ' num2str(k) ' after ' int2str(j+cr-1) ' evaluations']);
  figure(2)
  plot(pp,diffmeans)
  title(['Difference between true and random runs']);
  figure(gcf)
end

