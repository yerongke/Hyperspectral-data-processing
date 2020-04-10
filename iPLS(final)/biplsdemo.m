echo off
close all
clc
disp(' ')
disp('  This is a demo of the iToolbox backward interval PLS method')
disp(' ')
disp('  We start by making a biPLS model of near infrared data measured')
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
disp('  The model is run with 20 intervals, 10 PLS components, mean centered data,')
disp('  and 5 segments using syst123 cross validation')
disp(' ')
disp('  Use biModel=bipls(X,Y,no_of_lv,prepro_method,intervals,xaxislabels,val_method,segments);')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
echo on
biModel=bipls(Xcal,ycal,10,'mean',20,xaxis,'syst123',5); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause

disp('  See results in a table using biplstable(biModel);')
disp(' ')
echo on
biplstable(biModel); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause

disp('  In this case we decide to use intervals 6, 8 and 9')
disp('  Use FinalModel=plsmodel(Model,selected_intervals,no_of_lv,prepro_method,val_method,segments);')
disp('    to make a model with all model information based on these intervals')
disp(' ')
echo on
FinalModel=plsmodel(biModel,[6 8 9],10,'mean','syst123',5); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause

disp('  Use plsrmse(FinalModel) to see RMSECV as a function of number PLS components for the selected intervals')
disp(' ')
echo on
plsrmse(FinalModel); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
close all

disp('  In this case we decide to use 6 PLS components')
disp('  Use plspvsm(FinalModel,no_of_lv) to get a predicted versus measured plot')
disp(' ')
echo on
plspvsm(FinalModel,6); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
close all

home
disp('  This result can now be compared to e.g. the best single interval models')
disp(' ')
disp('  REMEMBER TO TEST THE MODEL ON AN INDEPENDENT TEST SET')
disp(' ')
disp('  END OF DEMO')
