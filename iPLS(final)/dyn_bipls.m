function var=dyn_bipls(dataset,nooflv,seqint,MinNoVars,varold,c)

%  dyn_bipls makes dynamic biPLS calculations with a number of intervals defined by the user
%  The output 'var' is plotted at the end of the calculation
%  NOTE: Calculations performed with 'syst123' and 'auto'
%
%  Input:
%    dataset: X and y in the same matrix; dataset=[X y];
%    nooflv: number of latent variables to calculate in each model
%    seqint: sequence of intervals in the runs, e.g. [16:25] or 20
%    MinNoVars is the number of variables to stop at in dynamic biPLS, e.g. 400
%    varold (optional) is the vector var obtained in previous runs, to which the results of the new runs will be added
%    c (optional) is the number of previous runs 
%  Output:
%    var: vector containing the number of times each variables has been retained
%
%  After each cycle the variables var and c (the number of performed cycles) are saved
%  This allows not to waste the partial results in case of a system failure and to add new runs
%
%  Riccardo Leardi, October 2003
%
%  var=dyn_bipls(dataset,nooflv,seqint,MinNoVars,varold,c);

if nargin==0
   disp(' ')
   disp(' var=dyn_bipls(dataset,nooflv,seqint,MinNoVars,varold,c);')
   disp(' ')
   disp(' Example:')
   disp(' var=dyn_bipls(dataset,15,[16:25],400,varold,10);')
   disp(' ')
   disp(' This means that a maximum of 15 latent variables are computed, the runs will be made on 16, 17, ..., 25 intervals')
   disp(' and no more than 400 variables will be retained; 10 runs have already been performed, and the number of times each')
   disp(' variable has been retained is stored in the vector varold')
   disp(' ')
   return
end

randomiz
[o,v]=size(dataset);
v=v-1;
if nargin==4
    c=0;
    var=zeros(1,v);
else
    var=varold;
end 
for i=1:size(seqint,2)
    c=c+1;
    k=randperm(o);
    vv=iplsprega(dataset(k,:),nooflv,seqint(i),MinNoVars);
    for j=1:size(vv,2)
        var(vv(j))=var(vv(j))+1;
    end
    close
    plot(var)
    set(gca,'XLim',[1 v])
    set(gca,'YLim',[0 max(var)+.1])
    [a,b]=sort(var);
    a=fliplr(a);
    hold on;
    plot([1 v],[a(MinNoVars)+.5 a(MinNoVars)+.5],'--')
    set(gca,'xlabel',text(0,0,['Wavelength number' ]));
    title(['Frequency of selections after ' int2str(c) ' cycles']); 
    drawnow
    save var var
    save c c
end

function retvar=iplsprega(dataset,nooflv,numint,MinNoVars)

% iplsprega performs iPLS in its backward form as a wavelength elimination tool
%   This is done preliminary to the application of GA (gaplssp)
%
% Input:
%   dataset: in the form usual for GA, with the y variable as the last variable
%   nooflv: number of latent variables to calculate in each model
%   numint: the number of intervals
%   MinNoVars is the number of variables to stop at in biPLS
% Output:
%   retvar: a vector with the indexes of the retained variables
%
%  Riccardo Leardi, October 2003
%
%  retvar=iplsprega(dataset,nooflv,numint,MinNoVars);

if nargin==0
   disp(' ')
   disp(' retvar=iplsprega(dataset,nooflv,numint,MinNoVars);')
   disp(' ')
   disp(' Example:')
   disp(' retvar=iplsprega(dataset,12,20,400);')
   disp(' ')
   return
end

[r,c]=size(dataset);
x=dataset(:,1:c-1);
y=dataset(:,c);
biplslimitModel=bipls_limit(x,y,nooflv,'auto',numint,MinNoVars,[],'syst123',5);
% max. nooflv comp., numint int., autosc., 5 del.gr. with venetian blinds.

biplstable(biplslimitModel); % prints the table of the results

retvar=bipls_vector_limit(biplslimitModel,size(x,2),numint);
% the vector retvar stores the variables retained by backward iPLS

% Subfunction
function randomiz
rand('seed',sum(100*clock))
randn('seed',sum(100*clock))
