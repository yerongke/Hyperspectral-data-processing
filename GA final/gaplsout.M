% Application of GA to the detection of outliers coupled to GA-PLS
%
% by R. Leardi
%
% Dipartimento di Chimica e Tecnologie Farmaceutiche ed Alimentari
% via Brigata Salerno (ponte) - 16147 GENOVA (ITALY)
% e-mail: riclea@dictfa.unige.it
%
% The syntax is: [ressq,counter]=gaplsout(dataset)
% The y variable is the last one
%
% The output matrix ressq reports the squared residuals for each run
% The output vector counter holds the number of runs in which each object has been predicted

function [ressq,counter]=gaplsout(total)
clc
format compact
randomiz
[tob,c]=size(total);
disp(['objects: ' int2str(tob)])
y=total(:,c);
v=c-1;
disp(['variables: ' int2str(v)]);
s1=[];s2=[];b=[];fin=[];ressq=zeros(tob,100);counter=zeros(1,tob);

evaluat=50; % 50 evaluations
objtr=30; % 30 objects in each training set
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
runs=ceil(100/((tob-objtr)/tob)); % the number of runs is computed in such a way that each object is predicted 100 times on average
el=3;

for r=1:runs
  disp(' ')
  disp(['run ' num2str(r)])
  trpr=randperm(tob);
  dataset=total(trpr(1:objtr),:);
  predset=total(trpr(objtr+1:tob),:);
  % computation of CV var. with all the variables
  % (the optimal number of components will be the maximum for GA)
  start=0;
  while start==0
    [maxcomp,start,mxi,sxi,myi,syi]=plsgacv(dataset(:,1:v),y(trpr(1:objtr)),aut,ng,15);
  end
  disp(' ')
  disp(['With all the variables:'])
  disp(['components: ' int2str(maxcomp)])
  disp(['C.V. variance: ' num2str(start)])
  % creation and evaluation of the starting population
  crom=zeros(cr,v);
  resp=zeros(cr,1);
  comp=zeros(cr,1);
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
      [fac,risp]=plsgacv(dataset(:,var),y(trpr(1:objtr)),aut,ng,maxcomp,mxi(:,var),sxi(:,var),myi,syi);
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
        p(1,:)=crom(1,:);
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
	[fac,risp]=plsgacv(dataset(:,var),y(trpr(1:objtr)),aut,ng,maxcomp,mxi(:,var),sxi(:,var),myi,syi);
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
      [nc,rispmax,compmax,cc,maxrisp,libb]=backw(r,cr,crom,resp,numvar,cc,dataset,y(trpr(1:objtr)),aut,ng,maxcomp,maxrisp,libb,mxi,sxi,myi,syi,el);
      if isempty(nc)~=1
	[crom,resp,comp,numvar]=update(cr,crom,nc,resp,comp,numvar,rispmax,compmax,find(nc));
      end
    end

  end

  if endb=='Y' % final stepwise
    [nc,rispmax,compmax,cc,maxrisp,libb]=backw(r,cr,crom,resp,numvar,cc,dataset,y(trpr(1:objtr)),aut,ng,maxcomp,maxrisp,libb,mxi,sxi,myi,syi,el);
    if isempty(nc)~=1
      [crom,resp,comp,numvar]=update(cr,crom,nc,resp,comp,numvar,rispmax,compmax,find(nc));
    end
  end

  selvar=find(crom(1,:));

  [e]=predpls(dataset(:,selvar),y(trpr(1:objtr)),predset(:,selvar),y(trpr(objtr+1:tob)),comp(1),aut);
%                 disp(trpr)
%                 disp(' ')
%                 disp(selvar)
%                 disp(' ')
%                 disp(e)
  for rescount=1:tob-30
    ressq(trpr(objtr+rescount),r)=(e(rescount)-predset(rescount,c))^2;
    counter(trpr(objtr+rescount))=counter(trpr(objtr+rescount))+1;
  end
  for jj=1:tob
    if counter(jj)>0
      meanressq(jj)=sum(ressq(jj,:))/counter(jj);
    else
      meanressq(jj)=0;
    end
  end
  figure(1)
  bar(sqrt(meanressq),'r');
  set(gca,'XLim',[0.5 tob+0.5]);
  title(['RMSEP of the objects of the training set' ]);
  figure(gcf)
end
figure(2)
[a,b]=hist(sqrt(meanressq),100);
bar(b,a,'r');

