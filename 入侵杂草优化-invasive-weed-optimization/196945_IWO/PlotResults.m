function PlotResults(t,y,name)

    figure;
    
    % t and y
    subplot(2,2,1);
    plot(y,'k');
    hold on;
    plot(t,'r:');
    legend('Outputs','Targets');
    title(name);
    
    % Correlation Plot
    subplot(2,2,2);
    plot(t,y,'ko');
    hold on;
    xmin=min(min(t),min(y));
    xmax=max(max(t),max(y));
    plot([xmin xmax],[xmin xmax],'b','LineWidth',2);
    R=corr(t',y');
    title(['R = ' num2str(R)]);
    
    % e
    subplot(2,2,3);
    e=t-y;
    plot(e,'b');
    legend('Error');
    MSE=mean(e.^2);
    RMSE=sqrt(MSE);
    title(['MSE = ' num2str(MSE) ', RMSE = ' num2str(RMSE)]);
    
    subplot(2,2,4);
    histfit(e,50);
    eMean=mean(e);
    eStd=std(e);
    title(['\mu = ' num2str(eMean) ', \sigma = ' num2str(eStd)]);
    
end