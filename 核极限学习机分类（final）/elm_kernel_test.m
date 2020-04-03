function Output = elm_kernel_test(TestingData, model)

% Usage: Output = elm_kernel_test(TestingData, model)

%
% Input:
% TestingData_File             - m*n training data with m instances and
%                                n-1 features and the first column represents the labels
% model                         -model trained by elm_kernel_train
% Output: 
%   Output                     -structure data
%                                  Output1.PredictLabel           PredictLabel                         
%                                  Output1.TestingAccuracy          TestingAccuracy
%                                  Output1.TestingTime              TestingTime
%

%Author: Yin Haibo
%Date :2015 10 25
%Reference on:
    %%%%    Authors:    MR HONG-MING ZHOU AND DR GUANG-BIN HUANG
    %%%%    NANYANG TECHNOLOGICAL UNIVERSITY, SINGAPORE
    %%%%    EMAIL:      EGBHUANG@NTU.EDU.SG; GBHUANG@IEEE.ORG
    %%%%    WEBSITE:    http://www.ntu.edu.sg/eee/icis/cv/egbhuang.htm
    %%%%    DATE:       MARCH 2012





%%%%%%%%%%% Load testing dataset
test_data=TestingData;
TestLabel=test_data(:,1);
TestData=test_data(:,2:end);



   

clear test_data;                                    %   Release raw testing data array
                                   

tic;
Kernel_type=model.Kernel_type;
Kernel_para=model.Kernel_para;
Omega_test = kernel_matrix(TestData,Kernel_type, Kernel_para,model.X);
TY=Omega_test * model.beta;
model.TrainingTime=toc;
MissClassificationRate_Testing=0;

[~,PredictLabelInx]=max(TY,[],2);
Output.PredictLabel=model.label(PredictLabelInx);


for i = 1 : size(TY, 1)
        if Output.PredictLabel(i)~=TestLabel(i)
            MissClassificationRate_Testing=MissClassificationRate_Testing+1;
        end
end
 Output.TestingAccuracy=1-MissClassificationRate_Testing/size(TY, 1);
 Output.TestingTime=toc;   
end

    
%%%%%%%%%%%%%%%%%% Kernel Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function omega = kernel_matrix(Xtrain,kernel_type, kernel_pars,Xt)

nb_data = size(Xtrain,1);


if strcmp(kernel_type,'RBF_kernel'),
    if nargin<4,
        XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        omega = exp(-omega./kernel_pars(1));
    else
        XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
        XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*Xtrain*Xt';
        omega = exp(-omega./kernel_pars(1));
    end
    
elseif strcmp(kernel_type,'lin_kernel')
    if nargin<4,
        omega = Xtrain*Xtrain';
    else
        omega = Xtrain*Xt';
    end
    
elseif strcmp(kernel_type,'poly_kernel')
    if nargin<4,
        omega = (Xtrain*Xtrain'+kernel_pars(1)).^kernel_pars(2);
    else
        omega = (Xtrain*Xt'+kernel_pars(1)).^kernel_pars(2);
    end
    
elseif strcmp(kernel_type,'wav_kernel')
    if nargin<4,
        XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        
        XXh1 = sum(Xtrain,2)*ones(1,nb_data);
        omega1 = XXh1-XXh1';
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
        
    else
        XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
        XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*(Xtrain*Xt');
        
        XXh11 = sum(Xtrain,2)*ones(1,size(Xt,1));
        XXh22 = sum(Xt,2)*ones(1,nb_data);
        omega1 = XXh11-XXh22';
        
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
    end
end
end