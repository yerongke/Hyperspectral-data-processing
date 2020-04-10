% The iToolbox
% Version 1 - July 2004
% Copyright (c) L. Nørgaard, Chemometrics Group, KVL, Denmark
%               R. Leardi, University of Genoa, Italy (bipls & dyn_bipls)
%
% PLS MODELS
%   ipls:       Calculates iPLS models
%   bipls:      Calculates backwards iPLS models
%                 (elimination of poor performing intervals)
%   mwpls:      Calculates iPLS models based on a moving window concept. For
%                  each variable a PLS model is calculated with the given windowsize
%   sipls:      Calculates PLS models on combinations (2, 3, or 4) of intervals
%   plsmodel:   Calculates ordinary PLS models on given intervals
%   plspredict: Prediction of new data based on plsmodel
%
% PCA MODELS
%   ipca:       Calculates iPCA models
%
% PLS MODELS - PLOTS & TABLES
%   iplsplot:       The iPLS bar plot
%   biplstable:     Displays the biPLS results
%   mwplsplot:      Plot of RMSECV/RMSEP for each variable calculated with mwpls
%   mwplsplot_comp: Plot of optimal number of components for each variable
%   siplstable:     Displays the interval combination with minimum RMSECV for each PLS component
%   plsrmse:        RMSECV/RMSEP for global or interval models
%   plspvsm:        Predicted versus measured for selected interval(s) or for global model
%
% PCA MODELS - PLOTS & TABLES
%   ipcascoplot:     Makes score plots for all intervals for two PCs
%   ipcascoplotall:  Makes all score plots for all intervals up to maxPC
%   ipcaloadplot:    Makes loading plots for all intervals
%   ipcavarexp:      Displays intervals and explained variance
%   makeClasses:     Example of a script for specification of sample classes (1 to maximum 7)
%   makeSampleNames: Example of a script for specification of sample names
%
% GENERAL TOOLS
%   intervals:            Table with information on all iPLS/biPLS/iPCA intervals including x-labels if given
%   makeManualSegments:   Example of a script for manual specification of segments for cross validation (not for iPCA)
%   makeManualIntervals:  Example of a script for manual specification of intervals
%   makeEntropyIntervals: Function for entropy calculation of intervals
%
% PREPROCESSING FOR GENETIC ALGORITHMS BY biPLS
%   dyn_bipls: Makes dynamic biPLS calculations
%              The output is used as a basis for the input to Leardi's GA Toolbox
%              also found at http://www.models.kvl.dk
%
% GETTING STARTED
%   iplsdemo (uses nirbeer.mat)
%   biplsdemo (uses nirbeer.mat)
%   mwplsdemo (uses nirbeer.mat)
%   siplsdemo (uses nirbeer.mat)
%   ipcademo (uses nirbeer.mat)
%   contents.m (this file)
%   Read iToolbox_Manual.pdf
