echo off
close all
clc
disp(' ')
disp('  This is a demo of the iToolbox investigating possible synergy between intervals')
disp(' ')
disp('  We start by making an siPLS model of near infrared data measured')
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
disp('  The model is run with 10 intervals (to save time....), 7 PLS components, mean centered data,')
disp('  and 5 segments using syst123 cross validation')
disp('  Combinations of two intervals are investigated')
disp(' ')
disp('  Use Model=siPLS(X,Y,no_of_lv,prepro_method,intervals,no_of_comb,xaxislabels,val_method,segments)')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
echo on
siModel=sipls(Xcal,ycal,7,'mean',10,2,xaxis,'syst123',5); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause

disp('  Use siplstable(siModel) to display optimal interval combinations')
disp('  corresponding RMSECV''s and PLS components')
disp(' ')
echo on
siplstable(siModel); echo off
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause

disp('  In this case we will use intervals 4 and 5 with 6 PLS components')
disp('  Use FinalModel=plsmodel(Model,selected_intervals,no_of_lv,prepro_method,val_method,segments);')
disp('    to make a model with all model information based on these intervals')
disp(' ')
echo on
FinalModel=plsmodel(siModel,[4 5],6,'mean','syst123',5); echo off
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
disp('  You can test all combinations of three and four intervals')
disp('  by just changing the no_of_int in')
disp(' ')
disp('  siModel=siPLS(Model,no_of_lv,prepro_method,no_of_int,val_method,segments);')
disp(' ')
disp('  to 3 or 4')
disp(' ')


disp(' ')
disp('  REMEMBER TO TEST THE MODEL ON AN INDEPENDENT TEST SET')
disp(' ')
disp('  END OF DEMO')
close all