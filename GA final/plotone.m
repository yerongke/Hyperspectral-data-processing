% plotone(dataset,b,fin,sel,precision)
function plotone(dataset,b,fin,sel,precision)
if nargin==4
  precision=0;
end
bmf=0;bmp=0;
[r,co]=size(dataset);
v=co-1;
figure(1)
[j,k]=sort(b);
bar(sel(k));
set(gca,'XLim',[0 v])
title(['Smoothed frequency of selections']); 
figure(gcf)
[x,k]=max(fin(2,:));
disp(['Maximum C.V.: ' num2str(x) ' obtained with ' int2str(fin(1,k)) ' variables (' int2str(fin(3,k)) ' comp.):']);
glob=b(1:fin(1,k));
disp(glob)

nonsignincr=fin(4,k)*(sqrt(finv(.9,r-1,r-1))-1) %nonsignincr is the increase in RMSECV non significant according to an F test (p=0.1)

if k<size(fin,2)
  h=(sel(fin(1,k))+sel(fin(1,k+1)))/2;
  hold on
  plot([1,v-1],[h h],'g');
end

if precision>0
   disp(' ')
   i=1;
   while fin(4,i)-fin(4,k)>precision
     i=i+1;
   end
   disp(['Suggested model according to the precision criterion: C.V.: ' num2str(fin(2,i)) ' obtained with ' int2str(fin(1,i)) ' variables (' int2str(fin(3,i)) ' comp.):']);
   sugg=b(1:fin(1,i));
   disp(sugg)
   h=(sel(fin(1,i))+sel(fin(1,i+1)))/2;
   hold on
   plot([1,v-1],[h h],'b');
   if (fin(4,i+1)-fin(4,k))<(fin(4,i)-fin(4,k))/2
     disp(['Better model: C.V.: ' num2str(fin(2,i+1)) ' obtained with ' int2str(fin(1,i+1)) ' variables (' int2str(fin(3,i+1)) ' comp.):']);
     suggb=b(1:fin(1,i+1));
     disp(suggb)
     h=(sel(fin(1,i+1))+sel(fin(1,i+2)))/2;
     hold on
     plot([1,v-1],[h h],'b --');
     bmp=1;
   end
end
disp(' ')
f=1;
while fin(4,f)-fin(4,k)>nonsignincr
  f=f+1;
end
disp(['Suggested model according to the F criterion: C.V.: ' num2str(fin(2,f)) ' obtained with ' int2str(fin(1,f)) ' variables (' int2str(fin(3,f)) ' comp.):']);
suggf=b(1:fin(1,f));
disp(suggf)
h=(sel(fin(1,f))+sel(fin(1,f+1)))/2;
hold on
plot([1,v-1],[h h],'r')
if (fin(4,f+1)-fin(4,k))<(fin(4,f)-fin(4,k))/2
  disp(['Better model: C.V.: ' num2str(fin(2,f+1)) ' obtained with ' int2str(fin(1,f+1)) ' variables (' int2str(fin(3,f+1)) ' comp.):']);
  suggb=b(1:fin(1,f+1));
  disp(suggb)
  h=(sel(fin(1,f+1))+sel(fin(1,f+2)))/2;
  hold on
  plot([1,v-1],[h h],'r --');
  bmf=1;
end
hold off

figure(2)
plot(fin(1,:),fin(2,:))
title(['C.V. as a function of the number of selected variables']);
hold on
plot(fin(1,k),fin(2,k),'g*')
if precision>0
  plot(fin(1,i),fin(2,i),'b*')
  if bmp==1
     plot(fin(1,i+1),fin(2,i+1),'b*')
  end
end
plot(fin(1,f),fin(2,f),'r*')
if bmf==1
   plot(fin(1,f+1),fin(2,f+1),'r*')
end
set(gca,'XLim',[0 v])
figure(gcf)
hold off
disp(' ')

figure(3)
plot(dataset(:,1:v)','r')
title(['Spectra and selected variables']);
set(gca,'XLim',[0 v])
gmin=min(min(dataset(:,1:v)));
gmax=max(max(dataset(:,1:v)));
rg=gmax-gmin;
set(gca,'YLim',[gmin-rg/5 gmax+rg/10]);
hold on
for ii=1:size(glob,2)
   plot([glob(ii)-.5 glob(ii)+.5],[gmin-rg/6.67 gmin-rg/6.67],'g');
end
if precision>0
  for ii=1:size(sugg,2)
    plot([sugg(ii)-.5 sugg(ii)+.5],[gmin-rg/10 gmin-rg/10],'b');
  end
end
for ii=1:size(suggf,2)
  plot([suggf(ii)-.5 suggf(ii)+.5],[gmin-rg/20 gmin-rg/20],'r');
end
hold off

figure(4)
plot(fin(1,:),fin(4,:))
title(['RMSECV as a function of the number of selected variables']);
hold on
plot(fin(1,:),fin(4,:),'o')
plot(fin(1,k),fin(4,k),'g*')
if precision>0
  plot(fin(1,i),fin(4,i),'b*')
  if bmp==1
     plot(fin(1,i+1),fin(4,i+1),'b*')
  end
end
plot(fin(1,f),fin(4,f),'r*')
if bmf==1
  plot(fin(1,f+1),fin(4,f+1),'r*')
end
set(gca,'XLim',[0 v])
figure(gcf)
hold off

TILEFIGS([2 2])

[r,co]=max(fin(2,:));disp(fin(:,1:co))

figure(1)
%zoomrb
figure(2)
%zoomrb
figure(3)
%zoomrb
figure(4)
%zoomrb
