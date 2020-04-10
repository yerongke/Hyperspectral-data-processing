function biplslimitModel=bipls_limit(X,Y,no_of_lv,prepro_method,intervals,MaxNoVars,xaxislabels,val_method,segments)

% Finds non-informative intervals by backwards elimination - the Leardi way...
% Uses sort_ipls.m (subfunction) and iplsreverse.m
%
% [RevIntInfo,RevRMSE,RevVars]=bipls_limit(X,Y,no_of_lv,intervals,cv_method,prepro_method,MaxNoVars,axislabels,segments);

if nargin==0
    disp(' ')
    disp(' biplslimitModel=bipls_limit(X,Y,no_of_lv,intervals,cv_method,prepro_method,MaxNoVars,xaxislabels,segments);')
    disp(' ')
    disp(' Example:')
    disp(' biplslimitModel=bipls_limit(X,Y,10,20,''syst123'',''mean'',400,[],5);')
    disp(' ')
    return
end

% ALSO IMPLEMENT WITH MANUAL CV AND TEST SET

ModelReverse=iplsreverse(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);
[temp1,temp2,minRMSEwithout(1),ix_for_iterative(1),minRMSEglobal(1)]=sort_ipls(ModelReverse);  % Subfunction is in this file
newX=X;
RevVars(1)=size(newX,2);
newX(:,ModelReverse.allint(ix_for_iterative(1),2):ModelReverse.allint(ix_for_iterative(1),3))=[];

keeptrackofinterval=[(1:intervals)' (1:intervals)'];
RevIntInfo(1,:)=keeptrackofinterval(ix_for_iterative(1),:);
keeptrackofinterval(ix_for_iterative(1),:)=[];
keeptrackofinterval(:,1)=(1:(intervals-1))';
%IntervalInformation=[(1:intervals)' ModelReverse.allint(1:intervals,:)];
for i=2:(intervals-1)
     RevVars(i)=size(newX,2);
     if RevVars(i)>MaxNoVars
        ModelReverse=iplsreverse(newX,Y,no_of_lv,prepro_method,intervals-(i-1),xaxislabels,val_method,segments);
        [temp1,temp2,minRMSEwithout(i),ix_for_iterative(i),minRMSEglobal(i)]=sort_ipls(ModelReverse);  % Subfunction is in this file
        newX(:,ModelReverse.allint(ix_for_iterative(i),2):ModelReverse.allint(ix_for_iterative(i),3))=[];
        RevIntInfo(i,:)=keeptrackofinterval(ix_for_iterative(i),:);
        keeptrackofinterval(ix_for_iterative(i),:)=[];
        keeptrackofinterval(:,1)=(1:(intervals-i))';
        %    IntervalInformation(ix_for_iterative,:)=[];
    	%    IntervalInformation(:,1)=(1:(intervals-(i-1)))';
     else 
        break
     end
end
l=length(minRMSEwithout);
RevRMSE=[minRMSEglobal'; minRMSEwithout(l)];
RevIntInfo(:,1)=[];
RevIntInfo(intervals)=keeptrackofinterval(1,2);
RevVars=[RevVars';size(newX,2)];

% function vec=findvec(IntervalInformation)
%     vec=[];
%     for i=1:(IntervalInformation)
%         vec=[vec [IntervalInformation(i,2) IntervalInformation(i,3)]];
%     end
% end

biplslimitModel.type='bipls_limit';
biplslimitModel.rawX=X;
biplslimitModel.rawY=Y;
biplslimitModel.no_of_lv=no_of_lv;
biplslimitModel.prepro_method=prepro_method;
biplslimitModel.intervals=intervals;
%biplslimitModel.allint=allint; 
%biplslimitModel.intervalsequi=intervalsequi; 
biplslimitModel.xaxislabels=xaxislabels;
biplslimitModel.val_method=val_method;
biplslimitModel.segments=segments;
biplslimitModel.RevIntInfo=RevIntInfo;
biplslimitModel.RevRMSE=RevRMSE;
biplslimitModel.RevVars=RevVars;

function [RMSEsorted,ix_sorted,RMSEmin,ix_for_iterative,minRMSEglobal]=sort_ipls(Model)
% Sorts intervals from iplsreverse according to predictive ability.
% Input: Model (output from iplsreverse)
% Output:
%   RMSEsorted: the lowest RMSE value for each interval, sorted according to size
%   ix_sorted: interval number, sorted according to lowest RMSE

AllRMSE=[];
for i=1:Model.intervals
    AllRMSE=[AllRMSE; Model.PLSmodel{i}.RMSE];
end

% IMPLEMENT WITHOUT PLSC0!!
SignMat=[sign(diff(AllRMSE')') ones(Model.intervals,1)];

for i=1:size(AllRMSE,1)
    for j=1:size(AllRMSE,2)
        if SignMat(i,j)==1
            % minRMSEcomp(i)=j; % To estimate number of components in final models NOT IMPLEMENTED
            minRMSEinInterval(i)=AllRMSE(i,j);
            break
        end
    end
end
minRMSEinInterval=minRMSEinInterval'; % Important for flipud function three lines later

[RMSEsorted,ix_sorted]=sort(minRMSEinInterval);
RMSEsorted=flipud(RMSEsorted);
ix_sorted=flipud(ix_sorted);
l=length(ix_sorted);
ix_for_iterative=ix_sorted(l);
RMSEmin=RMSEsorted(l);

% IMPLEMENT WITHOUT PLSC0!!
RedRMSEglobal=Model.PLSmodel{Model.intervals+1}.RMSE;
SignMat=[sign(diff(RedRMSEglobal')') 1];

for j=1:size(RedRMSEglobal,2)
    if SignMat(j)==1
        minRMSEglobal=RedRMSEglobal(j);
        break
    end
end
