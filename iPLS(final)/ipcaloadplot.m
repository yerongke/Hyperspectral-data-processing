function ipcaloadplot(Model,PCa,PCb,variablenames,no_of_plots_pr_figure)

%  ipcaloadplot makes 2D loading plots of PCa versus PCb for all intervals
%
%  Input:
%  Model (the output from ipca.m)
%  PCa and PCb designates the combination of loading vectors to use in the plot
%  variablenames: string, see makeSampleNames for an example (use [] if not available)
%  classvariable: vector of numbers (1 to n) assigning each class (1 to n) 
%                 see makeClass for an example (use [] if not available)
%                 up to n=7 classes can be coloured
%  no_of_plots_pr_figure must be 1, 2, 4, 6 or 8 (optional, default is 6)
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  ipcaloadplot(Model,PCa,PCb,variablenames,no_of_plots_pr_figure);

if nargin==0
   disp(' ')
   disp(' ipcaloadplot(Model,PCa,PCb,variablenames,no_of_plots_pr_figure);')
   disp(' ')
   disp(' Example:')
   disp(' ipcaloadplot(Model,1,2,[]);')
   disp(' ')
   return
end

[n,m] = size(Model.rawX);

set(0,'Units','pixels');
Scrsiz=get(0,'ScreenSize');
ScrLength=Scrsiz(3);
ScrHight=Scrsiz(4);
bdwidth=10;
% [left(->) bottom(up) width hight]
figpos=[0.1*ScrLength 0.15*ScrHight 0.85*ScrLength 0.75*ScrHight];

Color=['r' 'b' 'g' 'k' 'm' 'c' 'y' 'w'];
%Shape=['o' 's' 'd' 'v' 'p' '*' 'x' '+' '.' '^' '<' '>' 'h'];
%[Color(i) Shape(i)])

% Loading plot for global model
figure(1)
set(1,'Position',figpos)
plot(Model.PCAmodel{size(Model.allint,1)}.P(:,PCa),Model.PCAmodel{size(Model.allint,1)}.P(:,PCb),'w')
if nargin==3 | isempty(variablenames) % & isempty(classvariable))
	s=int2str([1:m]');
	text(Model.PCAmodel{size(Model.allint,1)}.P(:,PCa),Model.PCAmodel{size(Model.allint,1)}.P(:,PCb),s);
else
	text(Model.PCAmodel{size(Model.allint,1)}.P(:,PCa),Model.PCAmodel{size(Model.allint,1)}.P(:,PCb),variablenames);
%elseif isempty(variablenames)
	% for k=1:max(classvariable)
		% ix=find(classvariable==k);
		% text(Model.PCAmodel{size(Model.allint,1)}.P(ix,PCa),Model.PCAmodel{size(Model.allint,1)}.P(ix,PCb),int2str(classvariable(ix)),'Color',Color(k))
    % end
%else
	% for k=1:max(classvariable)
		% ix=find(classvariable==k);
		% text(Model.PCAmodel{size(Model.allint,1)}.P(ix,PCa),Model.PCAmodel{size(Model.allint,1)}.P(ix,PCb),variablenames(ix,:),'Color',Color(k))
    % end
end

if isempty(Model.xaxislabels)==1
   title(sprintf('Global model, Variables %g-%g',Model.allint(1,2),Model.allint(size(Model.allint,1),3)));
else
   wavstart=Model.xaxislabels(Model.allint(1,2));
   wavend=Model.xaxislabels(Model.allint(size(Model.allint,1),3));
   title(sprintf('Global model, Var. %g-%g, Wav. %g-%g',Model.allint(1,2),Model.allint(size(Model.allint,1),3),wavstart,wavend));
end
xlabel(sprintf('PC %g',PCa))
ylabel(sprintf('PC %g',PCb))
hold on
V=axis;
if sign(V(1))==sign(V(2)) & sign(V(3))==sign(V(4))
    % No lines through origo
elseif sign(V(1))==sign(V(2))
    plot([V(1) V(2)],[0 0],'-g')
elseif sign(V(3))==sign(V(4))
    plot([0 0],[V(3) V(4)],'-g')
else
    plot([V(1) V(2)],[0 0],'-g',[0 0],[V(3) V(4)],'-g')
end
hold off

% Plot loading plots for local models
if nargin<5 | ~ismember(no_of_plots_pr_figure,[1,2,4,6,8]),
    no_of_plots_pr_figure=6;
end
No_of_figures=ceil(Model.intervals/no_of_plots_pr_figure);
count=0;
for i=1:No_of_figures
   figure(i+1)
   set(i+1,'Position',figpos)
   for j=1:no_of_plots_pr_figure
      count=count+1;
      if count>Model.intervals, break, end

      if no_of_plots_pr_figure==1
          % One plot in one Figure
      elseif no_of_plots_pr_figure==2
          subplot(1,2,j)
      elseif no_of_plots_pr_figure==4
          subplot(2,2,j)
      elseif no_of_plots_pr_figure==8
          subplot(4,2,j)          
      else  % Default: no_of_plots_pr_figure==6
          subplot(3,2,j)
      end
      plot(Model.PCAmodel{count}.P(:,PCa),Model.PCAmodel{count}.P(:,PCb),'w')
      if nargin==3 | isempty(variablenames)   % & isempty(classvariable)) for colouring code, to be implemented
	     s=int2str([1:size(Model.PCAmodel{count}.P(:,PCa),1)]');
         text(Model.PCAmodel{count}.P(:,PCa),Model.PCAmodel{count}.P(:,PCb),s);
      else 
         text(Model.PCAmodel{count}.P(:,PCa),Model.PCAmodel{count}.P(:,PCb),variablenames(Model.allint(count,2):Model.allint(count,3),:));

      % For colouring code, to be implemented
      %elseif isempty(variablenames)
         % for k=1:max(classvariable)
            % ix=find(classvariable==k);
            % text(Model.PCAmodel{count}.P(ix,PCa),Model.PCAmodel{count}.P(ix,PCb),int2str(classvariable(ix)),'Color',Color(k))
         % end
      %else
         % for k=1:max(classvariable)
            % ix=find(classvariable==k);
            % text(Model.PCAmodel{count}.P(ix,PCa),Model.PCAmodel{count}.P(ix,PCb),variablenames(ix,:),'Color',Color(k))
         % end
      end
      
      if isempty(Model.xaxislabels)==1
        title(sprintf('Int%g, Variables %g-%g',count,Model.allint(count,2),Model.allint(count,3)));
      else
        wavstart=Model.xaxislabels(Model.allint(:,2));
        wavend=Model.xaxislabels(Model.allint(:,3));
        title(sprintf('Int%g, Var. %g-%g, Wav. %g-%g',count,Model.allint(count,2),Model.allint(count,3),wavstart(count),wavend(count)));
      end
      xlabel(sprintf('PC %g',PCa))
 	  ylabel(sprintf('PC %g',PCb))
	  hold on
	  V=axis;
      if sign(V(1))==sign(V(2)) & sign(V(3))==sign(V(4))
          % No lines through origo
	  elseif sign(V(1))==sign(V(2))
            plot([V(1) V(2)],[0 0],'-g')
	  elseif sign(V(3))==sign(V(4))
            plot([0 0],[V(3) V(4)],'-g')
	  else
            plot([V(1) V(2)],[0 0],'-g',[0 0],[V(3) V(4)],'-g')
	  end
	  hold off
   end
end
