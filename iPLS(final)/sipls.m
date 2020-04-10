function siModel=sipls(X,Y,no_of_lv,prepro_method,intervals,no_of_comb,xaxislabels,val_method,segments)

%  sipls calculates PLS models on intervals combinations (2, 3, or 4)
%
%  Input:
%  X: independent data
%  Y: dependent data
%  no_of_lv is the maximum number of PLS components
%  prepro_method: 'none', 'mean', 'auto', 'mscmean' or 'mscauto'
%  intervals: number of intervals
%  no_of_comb: number of interval combinations tested (2, 3 or 4)
%  xaxislabels: wavelength/wavenumber labels
%  val_method is 'test', 'full', 'syst111', 'syst123', 'random', or 'manual'
%  segments (segments = number of samples corresponds to full cv)
%
%  Output:
%  siModel is a structured array containing model information.
%  Only RMSECV/RMSEP (siModel.RMSE) as a function of the number of PLS components for each model
%    is saved together with an index (siModel.IntComb) of the interval combination.
%  siModel.minRMSE stores the minimum RMSECV/RMSEP for each PLS component. The corresponding
%  pair of intervals is stored in siModel.minComb
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  siModel=sipls(X,Y,no_of_lv,prepro_method,intervals,no_of_comb,xaxislabels,val_method,segments);

if nargin==0
   disp(' ')
   disp(' siModel=sipls(X,Y,no_of_lv,prepro_method,intervals,no_of_comb,xaxislabels,val_method,segments);')
   disp(' ')
   disp(' Example:')
   disp(' siModel=sipls(X,Y,10,''mean'',20,2,[],''syst123'',5);')
   disp(' ')
   return
end

siModel.type='siPLS';
siModel.no_of_comb=no_of_comb;
siModel.rawX=X;
siModel.rawY=Y;
siModel.no_of_lv=no_of_lv;
siModel.prepro_method=prepro_method;
siModel.xaxislabels=xaxislabels;
siModel.val_method=val_method;
if nargin<9 & strcmp(val_method,'full')
    siModel.segments=size(X,1);
elseif nargin==9 & strcmp(val_method,'full')
    siModel.segments=size(X,1);
else
    siModel.segments=segments;    
end
siModel.intervals=intervals;

% Calculate intervals
[nint,mint]=size(intervals);
[n,m]=size(X);
if mint > 1
    siModel.allint=[(1:round(mint/2)+1)' [intervals(1:2:mint)';1] [intervals(2:2:mint)';m]];
    siModel.intervals=round(mint/2);
    siModel.intervalsequi=0;
else
    siModel.intervals=intervals;
    vars_left_over=mod(m,intervals);
    N=fix(m/intervals);
    % Distributes vars_left_over in the first "vars_left_over" intervals
    startint=[(1:(N+1):(vars_left_over-1)*(N+1)+1)'; ((vars_left_over-1)*(N+1)+1+1+N:N:m)'];
    endint=[startint(2:intervals)-1; m];
    siModel.allint=[(1:intervals+1)' [startint;1] [endint;m]];
    siModel.intervalsequi=1;
end

% Error checks
if nargin==6 % Here test set is to be implemented
end

switch no_of_comb
  case 2 % Two interval models
	Total=siModel.intervals*(siModel.intervals-1)/2;
	disp(sprintf('In total %g models are to be made',Total));
    pause(2)
	count=0;
	for i=1:siModel.intervals-1
       for j=(i+1):siModel.intervals
          count=count+1;
          home, disp(sprintf('Working on model no. %g of %g...',count,Total));
          int1=siModel.allint(i,2):siModel.allint(i,3);
          int2=siModel.allint(j,2):siModel.allint(j,3);
          selected_vars=[int1 int2];
          PLSmodel = pls_val(siModel.rawX(:,selected_vars),siModel.rawY,no_of_lv,prepro_method,val_method,siModel.segments);
          siModel.IntComb{count}=[i j];
          siModel.RMSE{count}=PLSmodel.RMSE;
       end
	end
 
  case 3 % Three interval models
	Total=prod((siModel.intervals-3+1):siModel.intervals)/prod(1:3);
	selected_vars=zeros(Total,3);
	disp(sprintf('In total %g models are to be made',Total));
	% Calculate models based on 1 to n intervals and estimate calculation time ?
	count=0;
	for i=1:siModel.intervals-1
       for j=(i+1):siModel.intervals
          for k=(j+1):siModel.intervals
             count=count+1;
      		 home, disp(sprintf('Working on model no. %g of %g...',count,Total));
             int1=siModel.allint(i,2):siModel.allint(i,3);
         	 int2=siModel.allint(j,2):siModel.allint(j,3);
             int3=siModel.allint(k,2):siModel.allint(k,3);
         	 selected_vars=[int1 int2 int3];
         	 PLSmodel = pls_val(siModel.rawX(:,selected_vars),siModel.rawY,no_of_lv,prepro_method,val_method,siModel.segments);
          	 siModel.IntComb{count}=[i j k];
      	     siModel.RMSE{count}=PLSmodel.RMSE;
          end
       end
	end

  case 4 % Four interval models
	Total=prod((siModel.intervals-4+1):siModel.intervals)/prod(1:4);
	selected_vars=zeros(Total,4);
	disp(sprintf('In total %g models are to be made',Total));
	% Calculate models based on 1 to n intervals and estimate calculation time ?
	count=0;
	for i=1:siModel.intervals-1
       for j=(i+1):siModel.intervals
          for k=(j+1):siModel.intervals
             for l=(k+1):siModel.intervals
			    count=count+1;
       		    home, disp(sprintf('Working on model no. %g of %g...',count,Total));
          		int1=siModel.allint(i,2):siModel.allint(i,3);
          		int2=siModel.allint(j,2):siModel.allint(j,3);
		        int3=siModel.allint(k,2):siModel.allint(k,3);
       	        int4=siModel.allint(l,2):siModel.allint(l,3);
          	    selected_vars=[int1 int2 int3 int4];
          		PLSmodel = pls_val(siModel.rawX(:,selected_vars),siModel.rawY,no_of_lv,prepro_method,val_method,siModel.segments);
		      	siModel.IntComb{count}=[i j k l];
       	        siModel.RMSE{count}=PLSmodel.RMSE;
             end
          end
       end
	end
end

for i=1:Total
   RMSE(i,:)=siModel.RMSE{i};
end

% First local minima is better; could be changed using e.g. F-test or equal NOT IMPLEMENTED
% Ones appended to make the search stop if the first local miminum is the last PLSC
RedRMSE=RMSE(:,2:end); % PLSC0 is excluded in finding the first local minimum
SignMat=[sign(diff(RedRMSE')') ones(Total,1)];

for i=1:size(RedRMSE,1) % equal to Total
    for j=1:size(RedRMSE,2)
        if SignMat(i,j)==1
            min_ix(i)=j; % Note: PLSC0 is excluded
            minRMSE(i)=RedRMSE(i,j); % Note: PLSC0 is excluded
            break
        end
    end
end

[siModel.minRMSE,Index]=sort(minRMSE); % Find the lowest RMSEs of total number of models

for j=1:10 % Show ten best models
   siModel.minComb{j}=siModel.IntComb{Index(j)};
   siModel.minPLSC(j)=min_ix(Index(j));
end
