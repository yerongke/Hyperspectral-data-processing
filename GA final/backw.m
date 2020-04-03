% function backw performs backward selection
function [nc,rispmax,compmax,cc,maxrisp,libb]=backw(r,cr,crom,resp,numvar,cc,dataset,y,aut,ng,maxcomp,maxrisp,libb,mxi,sxi,myi,syi,el);
% verifying the list of the already "backwarded" chromosomes
test1=1;
crb=0;ncp=[];rispmax=[];compmax=[];
if isempty(libb)==0
  while test1==1 & crb<size(crom,1)
    crb=crb+1;
    j=0;
    test2=1;
    while test2==1 & j<size(libb,1)
      j=j+1;
      if crom(crb,:)==libb(j,:)
        test2=0;
      end
    end
    if test2==1
      test1=0;	
    end
  end
else
  crb=1;
end

impr=1;
nc=crom(crb,:);
startresp=resp(crb,:);
while impr==1
  impr=0;
  libb=[libb;nc];
  start=find(nc);
  startvar=size(start,2);
  if startvar>1
    for i=1:startvar
      varr=start;
      varr(i)=[];
      cc=cc+1;
      if el==3;
      	[fac,risp]=plsgacv(dataset(:,varr),y,aut,ng,maxcomp,mxi(:,varr),sxi(:,varr),myi,syi);
      else
      	[fac,risp]=plsgacv(dataset(:,varr),y,aut,ng,maxcomp,mxi(:,varr),sxi(:,varr));
      end
      if risp>=startresp
        impr=1;
        ncp=nc;
        ncp(:,start(i))=0;
        rispmax=risp;
        compmax=fac;
        startresp=risp;
        if risp>maxrisp
          disp(['ev. ' int2str(cc) ' - ' num2str(risp)])
          maxrisp=risp;
        end
      end
    end
    nc=ncp;
  end
end
