% Application of GA to the selection of the "best" subset
% for a PLS regression.
%
% by R. Leardi
%
% Dipartimento di Chimica e Tecnologie Farmaceutiche ed Alimentari
% via Brigata Salerno (ponte) - 16147 GENOVA (ITALY)
% e-mail: riclea@dictfa.unige.it
%
% The syntax is: [b,fin,sel]=gapls(dataset,evaluat)
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
% This version has no interactive input, and therefore repeated series
% of runs can be performed.
% 2 input parameters have to be specified:
% 1) data set
% 2) number of evaluations per run

function [b,fin,sel]=gapls(dataset,evaluat)
clc
format compact
randomiz
[o,c]=size(dataset);
disp(['objects: ' int2str(o)])
y=dataset(:,c);
v=c-1;
disp(['variables: ' int2str(v)]);
s1=[];s2=[];b=[];fin=[];sel=[];

aut=2; % autoscaling; 0=raw data; 1=column centering
ng=5; % 5 deletion groups
cr=30; % 30 chromosomes
probsel=5/v; % on average 5 variables per chromosome in the orig. pop.
maxvar=30; % 30 variables as a maximum
probmut=0.01; % probability of mutation 1%
probcross=0.5; % probability of cross-over 50%
freqb=100; % backward stepwise every 100 evaluations 
if floor(evaluat/100)==evaluat/100;
  endb='N';
else
  endb='Y';
end
runs=100; % 100 runs
el=3;

% computation of CV var. with all the variables
% (the optimal number of components will be the maximum for GA)
[maxcomp,start,mxi,sxi,myi,syi]=plsgacv(dataset(:,1:v),y,aut,ng,15);
disp(' ')
disp(['With all the variables:'])
disp(['components: ' int2str(maxcomp)])
disp(['C.V. variance: ' num2str(start)])

sel=zeros(1,v); % sel stores the frequency of selection
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
  nextb=freqb;
  cc=0;
  while cc<cr
    den=0;
    sumvar=0;
    while (sumvar==0 | sumvar>maxvar)
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
        [s1,s2]=chksubs(cc,crom(1:cc,:),a);
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
	[fac,risp]=plsgacv(dataset(:,var),y,aut,ng,maxcomp,mxi(:,var),sxi(:,var),myi,syi);
        lib=[s(i,:);lib];
        if risp>maxrisp
          disp(['ev. ' int2str(cc) ' - ' num2str(risp)])
          maxrisp=risp;
        end
        if risp>resp(cr)
          [crom,resp,comp,numvar]=update(cr,crom,s(i,:),resp,comp,numvar,risp,fac,var);
        end
      end
    end

    % stepwise
    if cc>=nextb
      nextb=nextb+freqb;
      [nc,rispmax,compmax,cc,maxrisp,libb]=backw(r,cr,crom,resp,numvar,cc,dataset,y,aut,ng,maxcomp,maxrisp,libb,mxi,sxi,myi,syi,el);
      if isempty(nc)~=1
	[crom,resp,comp,numvar]=update(cr,crom,nc,resp,comp,numvar,rispmax,compmax,find(nc));
      end
    end

  end

  if endb=='Y' % final stepwise
    [nc,rispmax,compmax,cc,maxrisp,libb]=backw(r,cr,crom,resp,numvar,cc,dataset,y,aut,ng,maxcomp,maxrisp,libb,mxi,sxi,myi,syi,el);
    if isempty(nc)~=1
      [crom,resp,comp,numvar]=update(cr,crom,nc,resp,comp,numvar,rispmax,compmax,find(nc));
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

disp('Stepwise according to the frequency of selection');
[a,b]=sort(-sel);
sel=-a;
fin=[];
k=v-1;
if v-1>200
  k=200;
end
for c=1:k
  if sel(c)>sel(c+1)
    [fac,risp]=plsgacv(dataset(:,b(1:c)),y,aut,ng,maxcomp,mxi(:,b(1:c)),sxi(:,b(1:c)),myi,syi);
    sep=sqrt(1-risp/100)*syi(ng+1);sep=sep-sep/(2*o-2); %formula "approssimata" per calcolare sep da % var. sp.
    fin=[fin [c;risp;fac;sep]];
    disp(' ')
    disp(['With ' int2str(c) ' var. ' num2str(risp) ' (' int2str(fac) ' comp.)'])
  end
end

figure(2)
plot(fin(1,:),fin(2,:))
title(['C.V. as a function of the number of selected variables']);
figure(gcf)
disp(' ')
[x,k]=max(fin(2,:));
disp(['Maximum C.V.: ' num2str(x) ' obtained with ' int2str(fin(1,k)) ' variables (' int2str(fin(3,k)) ' comp.):']);
disp(b(1:fin(1,k)))

