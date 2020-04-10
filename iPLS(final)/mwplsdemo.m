echo off
close all
clc
disp(' ')
disp('  This is a demo of the iToolbox moving window PLS method')
disp(' ')
disp('  We start by making a mwPLS model of near infrared data measured')
disp('  on 40 beers with originale extract as y-variable (20 samples are')
disp('  put away in an independent test set)')
disp(' ')
disp('  Load the data')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
echo on
load nirbeer; echo off
disp(' ')
disp('  The model is run with windowsize 31, 10 PLS components, mean centered data,')
disp('  and 5 segments using syst123 cross validation')
disp(' ')
disp('  Use mwModel=mwpls(X,Y,no_of_lv,prepro_method,windowsize,xaxislabels,val_method,segments);')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
echo on
mwModel=mwpls(Xcal,ycal,10,'mean',31,xaxis,'syst123',5); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause

disp('  Plot the results using mwplsplot(ModelMW,optimal_lv_global,labeltype);')
disp(' ')
echo on
mwplsplot(mwModel); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause

disp(' ')
disp('  END OF DEMO')
close all