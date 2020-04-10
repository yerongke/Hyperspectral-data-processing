function plsrmse(Model,interval)

%  plsrmse plots RMSECV/RMSEP/RMSEC as a function of the number of PLS components
%
%  Input:
%  Model (the output from ipls.m)
%  interval is optional for selecting RMSECV/RMSEP/RMSEC for one interval or global model (use 0)
%
%  Copyright, Chemometrics Group - KVL, Copenhagen, Denmark
%  Lars Nørgaard, July 2004
%
%  plsrmse(Model,interval);

if nargin==0
  disp(' ')
  disp(' plsrmse(Model,interval);')
  disp(' or')
  disp(' plsrmse(Model);')
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
  case 'PLS' % When output is from plsmodel, i.e., a single model is calculated
    bar(0:Model.no_of_lv,Model.PLSmodel{Model.intervals}.RMSE)
    axis('tight')
    actualaxis=axis;
    axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)*1.1]) % *1.1 to give some space in the plot
    switch Model.val_method
      case 'none'
        figtitle = sprintf(['RMSEC (fit) versus PLS components for model on interval:  ' int2str(Model.selected_intervals)]);
      case 'test'
        figtitle = sprintf(['RMSEP (dependent) versus PLS components for model on interval:  ' int2str(Model.selected_intervals)]);
      otherwise
        figtitle = sprintf(['RMSECV versus PLS components for model on interval:  ' int2str(Model.selected_intervals)]);
    end % switch
    title(figtitle)
    xlabel('Number of PLS components')
    switch Model.val_method
      case 'none'
        ylabel('RMSEC')
      case 'test'
        ylabel('RMSEP')
      otherwise
        ylabel('RMSECV')
    end % switch
    
  case 'iPLS'
    if nargin==2
      if interval==0
        interval=Model.intervals+1;
        switch Model.val_method
          case 'none'
            figtitle = sprintf('RMSEC (fit) versus PLS components for global model');
          case 'test'
            figtitle = sprintf('RMSEP (dependent) versus PLS components for global model');
          otherwise
            figtitle = sprintf(' ');            
        end % switch
      else
        switch Model.val_method
          case 'none'
            figtitle = sprintf('RMSEC (fit) versus PLS components for model on interval %g',interval);
          case 'test'
            figtitle = sprintf('RMSEP (dependent) versus PLS components for model on interval %g',interval);
          otherwise
            figtitle = sprintf('RMSECV versus PLS components for model on interval %g',interval);
        end % switch Model.val_method
      end
      bar(0:Model.no_of_lv,Model.PLSmodel{interval}.RMSE)
      axis('tight')
      actualaxis=axis;
      axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)*1.1]) % *1.1 to give some space in the plot
      title(figtitle)
      xlabel('Number of PLS components')
      switch Model.val_method
        case 'none'
          ylabel('RMSEC')
        case 'test'
          ylabel('RMSEP')
        otherwise
          ylabel('RMSECV')
      end % switch Model.val_method
    elseif nargin == 1
      for i=1:(Model.intervals+1)
   	    RMSE(i,:) = Model.PLSmodel{i}.RMSE;
      end
      plot(0:Model.no_of_lv,RMSE(1:Model.intervals,:)')
      actualaxis=axis;
      axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)])
      switch Model.val_method
        case 'none'
          figtitle = sprintf('RMSEC (fit) versus PLS components for all interval models, -o- is RMSEC for the global model');
        case 'test'
          figtitle = sprintf('RMSEP (dependent) versus PLS components for all interval models, -o- is RMSEP for the global model');
        otherwise
          figtitle = sprintf('RMSECV versus PLS components for all interval models, -o- is RMSECV for the global model');
      end % switch
      title(figtitle)
      xlabel('Number of PLS components')
      switch Model.val_method
        case 'none'
          ylabel('RMSEC')
        case 'test'
          ylabel('RMSEP')
        otherwise
          ylabel('RMSECV')
      end % switch
      hold on
	  plot(0:Model.no_of_lv,RMSE(Model.intervals+1,:),'og')
	  plot(0:Model.no_of_lv,RMSE(Model.intervals+1,:),'-g')
      hold off
    end % if nargin==2
    
  case 'PLSprediction' % When output is from plspredict
    bar(0:Model.no_of_lv,Model.RMSE)
    axis('tight')
    actualaxis=axis;
    axis([actualaxis(1) actualaxis(2) 0 actualaxis(4)*1.1]) % *1.1 to give some space in the plot
    figtitle = sprintf(['RMSEP (independent) versus PLS components for model on interval:  ' int2str(Model.CalModel.selected_intervals)]);
    title(figtitle)
    xlabel('Number of PLS components')
    ylabel('RMSEP')
     
end % switch Model.type
