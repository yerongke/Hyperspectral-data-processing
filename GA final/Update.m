% function update updates the population
function [crom,resp,comp,numvar]=update(cr,crom,s,resp,comp,numvar,risp,fac,var)
[s1,s2]=CHKSUBS(cr,crom,s);
if isempty(s2)
  mm=0;
else
  mm=max(resp(s2));
end
if risp>mm  % the new chrom. survives only if better
  resp=[resp;risp];
  comp=[comp;fac];
  crom=[crom;s];
  numvar=[numvar;size(var,2)];
  for kk=1:size(s1,2)
    if risp>=resp(s1(kk))
      resp(s1(kk))=0; % the old chrom. are killed if worse
    end
  end
  [vv,pp]=sort(resp);
  pp=flipud(pp);
  crom=crom(pp,:);
  resp=resp(pp,:);
  comp=comp(pp,:);
  numvar=numvar(pp,:);
  pr=zeros(cr+1,1); %%% pr stores the index of the prot. chrom. %%%
  for ipr=1:max(numvar)
    prot=find(numvar<=ipr&numvar>0);
    if isempty(prot)==0
      pr(prot(1))=1;
    end
  end
  prot=find(pr==0);
  el=max(prot); %%% el is the chrom. to be eliminated %%%
  crom(el,:)=[];
  resp(el,:)=[];
  comp(el,:)=[];
  numvar(el,:)=[];
end

