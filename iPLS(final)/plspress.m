function plspress(Model,interval)

%  plspress plots PRESS as a function of the number of PLS components
%
%  Input:
%  Model (the output from ipls.m or plsmodel.m)
%  interval is optional for selecting PRESS for one interval or global model (use 0)
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  plspress(Model,interval);

if nargin==0
   disp(' ')
   disp(' plspress(Model,interval);')
   disp(' or')
   disp(' plspress(Model);')
   disp(' ')
   return
end

if ~ismember(Model.type,{'PLS','iPLS','PLSprediction'})
    disp(' ')
    disp('This function only works with output from ipls.m, plsmodel.m or plspredict.m')
    disp(' ')
    return
end

switch Model.type
  case 'iPLS'
    if nargin == 2
      if interval==0
        interval=Model.intervals+1;
        figtitle = sprintf('PRESS versus PLS components for global model');
      else
        figtitle = sprintf('PRESS versus PLS components for model on interval %g',interval);
      end
      bar(0:Model.no_of_lv,Model.PLSmodel{interval}.Press)
      axis('tight')
      actualaxis=axis;
      axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)*1.1]) % *1.1 to give some space in the plot
      title(figtitle)
      xlabel('Number of PLS components')
      ylabel('PRESS')
    elseif nargin == 1
      for i=1:(Model.intervals+1)
        Press(i,:) = Model.PLSmodel{i}.Press;
      end
      plot(0:Model.no_of_lv,Press(1:Model.intervals,:)')
      actualaxis=axis;
      axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)])
      figtitle = sprintf('PRESS versus PLS components for all interval models, -o- is PRESS for the full spectrum model');
      title(figtitle)
      xlabel('Number of PLS components')
      ylabel('PRESS')
      hold on
        plot(0:Model.no_of_lv,Press(Model.intervals+1,:),'og')
        plot(0:Model.no_of_lv,Press(Model.intervals+1,:),'-g')
      hold off
	end
    
  case 'PLS'
    Press(1,:) = Model.PLSmodel{1}.Press;
	bar(0:Model.no_of_lv,Press(1:Model.intervals,:)')
    axis('tight')
    actualaxis=axis;
    axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)])
	figtitle = sprintf(['PRESS versus PLS components for model on interval(s):  ' int2str(Model.selected_intervals)]);
	title(figtitle)
	xlabel('Number of PLS components')
	ylabel('PRESS')
    
  case 'PLSprediction'
    Press(1,:) = Model.Press;
	bar(0:Model.no_of_lv,Press(1:Model.CalModel.intervals,:)')
    axis('tight')
    actualaxis=axis;
    axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)])
	figtitle = sprintf(['PRESS versus PLS components for model on interval(s):  ' int2str(Model.CalModel.selected_intervals)]);
	title(figtitle)
	xlabel('Number of PLS components')
	ylabel('PRESS')

end