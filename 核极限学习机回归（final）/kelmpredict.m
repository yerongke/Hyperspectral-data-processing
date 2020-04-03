function TY = kelmpredict (OutputWeight,Omega_test)

% Usage: elm(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
% OR:    [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
%
% Input:
% TrainingData_File           - Filename of training data set
% TestingData_File            - Filename of testing data set
% Elm_Type                    - 0 for regression; 1 for (both binary and multi-classes) classification
% Regularization_coefficient  - Regularization coefficient C
% Kernel_type                 - Type of Kernels:
%                                   'RBF_kernel' for RBF Kernel
%                                   'lin_kernel' for Linear Kernel
%                                   'poly_kernel' for Polynomial Kernel
%                                   'wav_kernel' for Wavelet Kernel
%Kernel_para                  - A number or vector of Kernel Parameters. eg. 1, [0.1,10]...
% Output: 
% TrainingTime                - Time (seconds) spent on training ELM
% TestingTime                 - Time (seconds) spent on predicting ALL testing data
% TrainingAccuracy            - Training accuracy: 
%                               RMSE for regression or correct classification rate for classification
% TestingAccuracy             - Testing accuracy: 
%                               RMSE for regression or correct classification rate for classification
%
% MULTI-CLASSE CLASSIFICATION: NUMBER OF OUTPUT NEURONS WILL BE AUTOMATICALLY SET EQUAL TO NUMBER OF CLASSES
% FOR EXAMPLE, if there are 7 classes in all, there will have 7 output
% neurons; neuron 5 has the highest output means input belongs to 5-th class
%
% Sample1 regression: [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm_kernel('sinc_train', 'sinc_test', 0, 1, ''RBF_kernel',100)
% Sample2 classification: elm_kernel('diabetes_train', 'diabetes_test', 1, 1, 'RBF_kernel',100)
%
    %%%%    Authors:    MR HONG-MING ZHOU AND DR GUANG-BIN HUANG
    %%%%    NANYANG TECHNOLOGICAL UNIVERSITY, SINGAPORE
    %%%%    EMAIL:      EGBHUANG@NTU.EDU.SG; GBHUANG@IEEE.ORG
    %%%%    WEBSITE:    http://www.ntu.edu.sg/eee/icis/cv/egbhuang.htm
   %%%%    DATE:       MARCH 2012

%%%%%%%%%%% Macro definition


%%%%%%%%%%% Load training dataset
                                %   Release raw training data array

%%%%%%%%%%% Load testing dataset
                            %   Release raw testing data array




TY=(Omega_test' * OutputWeight)';                            %   TY: the actual output of the testing data
TestingTime=toc

    
    
%%%%%%%%%%%%%%%%%% Kernel Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

