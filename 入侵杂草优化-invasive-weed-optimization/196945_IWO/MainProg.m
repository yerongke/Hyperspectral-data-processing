clc;
clear;
close all;

ptrain=0.8;
nPredict=3;





x=xlsread('data.xlsx',1);




delay=[nPredict nPredict+1 nPredict+2];%Time intervals

ndelay=length(delay);

Maxdelay=max(delay);

N=numel(x);
Range=(Maxdelay+1):N;

inputs = zeros(ndelay,numel(Range));
for k=1:ndelay
    d=delay(k);
    inputs(k,:)=x(Range-d);
end
inputs=inputs';
targets = x(Range);

[Ndata,Ninput]=size(x);




inputs=inputs';
targets=targets';
% Create a Fitting Network
hiddenLayerSize = 5;
TF={'tansig','purelin'};
net = newff(inputs,targets,hiddenLayerSize,TF);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% For help on training function 'trainlm' type: help trainlm
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainlm';  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','ploterrhist','plotregression','plotfit'};

net.trainParam.showWindow=true;
net.trainParam.showCommandLine=false;
net.trainParam.show=1;
net.trainParam.epochs=500;
net.trainParam.goal=1e-8;
net.trainParam.max_fail=20;

for run=1:10
% Train the Network
[net,tr] = train(net,inputs,targets);
end




ShowResults(net)
