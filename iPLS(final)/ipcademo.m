echo off
close all
clc
disp(' ')
disp('  This is a demo of iPCA in the iToolbox')
disp(' ')
disp('  We want to make an iPCA model of near infrared data measured')
disp('  on 40 beers')
disp(' ')
disp('  Load the data')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
echo on
load nirbeer; echo off
disp(' ')
disp('  The model is run with 20 intervals, 7 PCA components on mean centered data')
disp(' ')
disp('  Use Model=ipca(X,no_of_lv,prepro_method,intervals,xaxislabels);')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
Model=ipca(Xcal,7,'mean',20,xaxis);
disp(' ')
disp('  Make class variable')
disp('  Use makeClasses')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
makeClasses
disp(' ')
disp('  Plot scores')
disp('  Use ipcascoplot(Model,PC1,PC2,samplenames,classes);')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
ipcascoplot(Model,1,2,[],classes);
disp(' ')
disp('  Make interval plot with variance explained for the first three variables')
disp('  Use ipcavarexp(Model,No_of_PC,labeltype);')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
close all
ipcavarexp(Model,3,'varlabel')
disp(' ')
disp('  Show interval information')
disp('  Use intervals(Model)')
disp(' ')
disp('  Press any key to continue')
disp(' ')
pause
close all
intervals(Model)
