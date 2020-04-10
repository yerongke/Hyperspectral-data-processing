function biModel=bipls(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments)

%  bipls: backwards elimination of non-informative intervals the Leardi way...
%
%  Input:
%  X is the independent variables
%  Y is the dependent variable(s), NOTE: Y is allways autoscaled
%  no_of_lv is the maximum number of PCA or PLS components
%  prepro_method (for X only) is 'mean', 'auto', 'mscmean' or 'mscauto'
%     Note: msc is performed in each interval
%  intervals is the number of intervals
%     if intervals is a row vector divisions are made based on the elements
%     [startint1 endint1 startint2 endint2 startint3 endint3], see an example in manint
%  xaxislabels (self explainable), if not available type []
%  val_method is 'test', 'full', 'syst111', 'syst123', 'random', or
%     'manual'; the last five are cross validation based methods
%  segments (segments = number of samples corresponds to full cv)
%     if intervals is a cell array cross validation is performed according
%     to this array, see the script makeManualSegments
%
%  Output:
%  biModel is a structured array containing all model information
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  biModel=bipls(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);

if nargin==0
    disp(' ')
    disp(' biModel=bipls(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);')
    disp(' ')
    disp(' Example:')
    disp(' biModel=bipls(X,Y,10,''mean'',20,[],''syst123'',5);')
    disp(' ')
    return
end

% Error checks
if ~ismember(val_method,{'test', 'full', 'syst123', 'syst111', 'random', 'manual'})
    disp(' Not allowed validation method')
    biModel=[];
    return
end

if ~ismember(prepro_method,{'mean', 'auto', 'mscmean', 'mscauto', 'none'})
    disp(' Not allowed preprocessing method')
    biModel=[];
    return
end
% End error checks

if strcmp(val_method,'full')
    segments=size(X,1);
end

ModelReverse=iPLSreverse(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);
[temp1,temp2,minRMSEwithout(1),ix_for_iterative(1),minRMSEglobal(1)]=sort_ipls(ModelReverse);  % Subfunction of this file

newX=X;
RevVars(1)=size(newX,2);
newX(:,ModelReverse.allint(ix_for_iterative(1),2):ModelReverse.allint(ix_for_iterative(1),3))=[];

keeptrackofinterval=[(1:intervals)' (1:intervals)'];
RevIntInfo(1,:)=keeptrackofinterval(ix_for_iterative(1),:);
keeptrackofinterval(ix_for_iterative(1),:)=[];
keeptrackofinterval(:,1)=(1:(intervals-1))';
%IntervalInformation=[(1:intervals)' ModelReverse.allint(1:intervals,:)];
for i=2:(intervals-1)
    %plot(newX'),pause
    RevVars(i)=size(newX,2);
    ModelReverse=iPLSreverse(newX,Y,no_of_lv,prepro_method,intervals-(i-1),xaxislabels,val_method,segments);
    [temp1,temp2,minRMSEwithout(i),ix_for_iterative(i),minRMSEglobal(i)]=sort_ipls(ModelReverse);  % Subfunction of this file
    newX(:,ModelReverse.allint(ix_for_iterative(i),2):ModelReverse.allint(ix_for_iterative(i),3))=[];
    RevIntInfo(i,:)=keeptrackofinterval(ix_for_iterative(i),:);
    keeptrackofinterval(ix_for_iterative(i),:)=[];
    keeptrackofinterval(:,1)=(1:(intervals-i))';
    %    IntervalInformation(ix_for_iterative,:)=[];
	%    IntervalInformation(:,1)=(1:(intervals-(i-1)))';
end
l=length(minRMSEwithout);
RevRMSE=[minRMSEglobal'; minRMSEwithout(l)];
RevIntInfo(:,1)=[];
RevIntInfo(intervals)=keeptrackofinterval(1,2);
RevVars=[RevVars';size(newX,2)];

% For subsequent use in plsmodel
[n,m]=size(X);
[nint,mint]=size(intervals);
if mint > 1
    allint=[(1:round(mint/2)+1)' [intervals(1:2:mint)';1] [intervals(2:2:mint)';m]];
    intervals=round(mint/2);
    intervalsequi=0;
else
    vars_left_over=mod(m,intervals);
    N=fix(m/intervals);
    % Distributes vars_left_over in the first "vars_left_over" intervals
    startint=[(1:(N+1):(vars_left_over-1)*(N+1)+1)'; ((vars_left_over-1)*(N+1)+1+1+N:N:m)'];
    endint=[startint(2:intervals)-1; m];
    allint=[(1:intervals+1)' [startint;1] [endint;m]];
    intervalsequi=1;
end

biModel.type='biPLS';
biModel.rawX=X;
biModel.rawY=Y;
biModel.no_of_lv=no_of_lv;
biModel.prepro_method=prepro_method;
biModel.intervals=intervals;
biModel.allint=allint; 
biModel.intervalsequi=intervalsequi; 
biModel.xaxislabels=xaxislabels;
biModel.val_method=val_method;
biModel.segments=segments;
biModel.RevIntInfo=RevIntInfo;
biModel.RevRMSE=RevRMSE;
biModel.RevVars=RevVars;

% function vec=findvec(IntervalInformation)
%     vec=[];
%     for i=1:(IntervalInformation)
%         vec=[vec [IntervalInformation(i,2) IntervalInformation(i,3)]];
%     end
% end

function [RMSEsorted,ix_sorted,RMSEmin,ix_for_iterative,minRMSEglobal]=sort_ipls(Model)
% Sorts intervals from iplsreverse according to predictive ability.
% Input: Model (output from iplsreverse)
% Output:
%   RMSEsorted: the first minimum RMSE value for each interval, sorted according to size
%   ix_sorted: interval number, sorted according to first minimum RMSE

AllRMSE=[];
for i=1:Model.intervals
    AllRMSE=[AllRMSE; Model.PLSmodel{i}.RMSE];
end

RedRMSE=AllRMSE(:,2:end); % PLSC0 is excluded in finding the first local minimum
SignMat=[sign(diff(RedRMSE')') ones(Model.intervals,1)];
for i=1:size(RedRMSE,1)
    for j=1:size(RedRMSE,2)
        if SignMat(i,j)==1
            % minRMSEcomp(i)=j; % To estimate number of components in final models NOT IMPLEMENTED
            minRMSEinInterval(i)=RedRMSE(i,j);
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

RedRMSEglobal=Model.PLSmodel{Model.intervals+1}.RMSE(2:end); % PLSC0 is excluded in finding the first local minimum
SignMat=[sign(diff(RedRMSEglobal')') 1];
for j=1:size(RedRMSEglobal,2)
    if SignMat(j)==1
        minRMSEglobal=RedRMSEglobal(j);
        break
    end
end
