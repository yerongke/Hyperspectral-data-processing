function ipcavarexp(Model,No_of_PCs,labeltype)

%  ipcavarexp makes a plot describing explained calibration variance for all intervals
%
%  Input:
%  Model (the output from iPCA.m)
%  No_of_PCs: the number of PCs to include in the plot
%  labeltype: 'intlabel', 'wavlabel' or 'varlabel'
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, February 2000
%
%  ipcavarexp(Model,No_of_PC,xaxislabel);

if nargin==0
   disp(' ')
   disp(' ipcavarexp(Model,No_of_PC,labeltype);')
   disp(' ')
   disp(' Example:')
   disp(' ipcavarexp(Model,4,''wavlabel'');')
   disp(' ')
   return
end

if Model.intervalsequi==0
   disp(' ')
   disp(' NOTE: X-axis for manually chosen intervals is not correctly plotted with this function')
   disp(' ')
end

Xmean = mean(Model.rawX); % Mean spectrum
if min(Xmean)<0
   Xmean=Xmean+(-min(Xmean)); % To make all intensities positive
end
[n,m] = size(Model.rawX);

No_Int = Model.intervals;
if strcmp(labeltype,'intlabel')
   Xtext = sprintf('Interval number');
   Xint =[Model.allint(1:No_Int,1)-0.5 Model.allint(1:No_Int,1)-0.5 Model.allint(1:No_Int,1)+0.5 Model.allint(1:No_Int,1)+0.5]';
elseif strcmp(labeltype,'wavlabel')
   if isempty(Model.axislabels)
      disp('You must define wavelength labels')
      return
   end
   Xtext = sprintf('Wavelength');
   a = Model.allint(1:No_Int,2);
   b = Model.allint(1:No_Int,3);
   Xint  = [Model.axislabels(a)' Model.axislabels(a)' Model.axislabels(b)' Model.axislabels(b)']';
elseif strcmp(labeltype,'varlabel')
   Xtext = sprintf('Variable number');
   Xint  = [Model.allint(1:No_Int,2) Model.allint(1:No_Int,2) Model.allint(1:No_Int,3) Model.allint(1:No_Int,3)]';
end

for i=1:(Model.intervals+1)
   varexp(i,:) = (Model.PCAmodel{i}.varexp(1:No_of_PCs,3))'; % or 2 for non-accumulated
end
set(0,'Units','pixels');
Scrsiz=get(0,'ScreenSize');
ScrLength=Scrsiz(3);
ScrHight=Scrsiz(4);
bdwidth=10;
% [left(->) bottom(up) width hight]
figpos=[0.1*ScrLength 0.15*ScrHight 0.85*ScrLength 0.75*ScrHight];

Color1=['r' 'c' 'g' 'm' 'b' 'c' 'y' 'w' 'k'];
Color2=colormap(cool); Color2=Color2(1:8:64,:);
set(figure(1),'Position',figpos)
for i=No_of_PCs:-1:1
   Response = [zeros(No_Int,1) varexp(1:No_Int,i) varexp(1:No_Int,i) zeros(No_Int,1)]';
   fill(Xint(:),Response(:),Color2(i,:))
   hold on
end
axis tight
title('Global (line), Intervals (bars)');
xlabel(Xtext)
ylabel(sprintf('Explained calibration variance in percent up to %g PCs',No_of_PCs))
hold on
for i=1:No_of_PCs
   hline(Model.PCAmodel{Model.intervals+1}.varexp(i,3),'-m')
end
axis tight;
actualaxis=axis;
Xaxis = linspace(actualaxis(1),actualaxis(2),m);
plot(Xaxis,Xmean./max(Xmean)*actualaxis(4),'-k') % Scaled spectrum
hold off
