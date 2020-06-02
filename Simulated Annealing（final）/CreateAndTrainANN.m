%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML122
% Project Title: Feature Selection using SA and ACO (Fixed Number of Features)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function results=CreateAndTrainANN(x,t)

    if ~isempty(x)
        
        % Choose a Training Function
        % For a list of all training functions type: help nntrain
        % 'trainlm' is usually fastest.
        % 'trainbr' takes longer but may be better for challenging problems.
        % 'trainscg' uses less memory. NFTOOL falls back to this in low memory situations.
        trainFcn = 'trainlm';  % Levenberg-Marquardt

        % Create a Fitting Network
        hiddenLayerSize = 10;
        net = fitnet(hiddenLayerSize,trainFcn);

        % Choose Input and Output Pre/Post-Processing Functions
        % For a list of all processing functions type: help nnprocess
        net.input.processFcns = {'removeconstantrows','mapminmax'};
        net.output.processFcns = {'removeconstantrows','mapminmax'};

        % Setup Division of Data for Training, Validation, Testing
        % For a list of all data division functions type: help nndivide
        net.divideFcn = 'dividerand';  % Divide data randomly
        net.divideMode = 'sample';  % Divide up every sample
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;

        % Choose a Performance Function
        % For a list of all performance functions type: help nnperformance
        net.performFcn = 'mse';  % Mean squared error

        % Choose Plot Functions
        % For a list of all plot functions type: help nnplot
        net.plotFcns = {};
        % net.plotFcns = {'plotperform','plottrainstate','ploterrhist', 'plotregression', 'plotfit'};

        net.trainParam.showWindow=false;
        
        % Train the Network
        [net,tr] = train(net,x,t);

        % Test the Network
        y = net(x);
        e = gsubtract(t,y);
        E = perform(net,t,y);
        
    else        
        
        y=inf(size(t));
        e=inf(size(t));
        E=inf;
        
        tr.trainInd=[];
        tr.valInd=[];
        tr.testInd=[];
        
    end

    % All Data
    Data.x=x;
    Data.t=t;
    Data.y=y;
    Data.e=e;
    Data.E=E;
    
    % Train Data
    TrainData.x=x(:,tr.trainInd);
    TrainData.t=t(:,tr.trainInd);
    TrainData.y=y(:,tr.trainInd);
    TrainData.e=e(:,tr.trainInd);
    if ~isempty(x)
        TrainData.E=perform(net,TrainData.t,TrainData.y);
    else
        TrainData.E=inf;
    end
    
    % Validation and Test Data
    TestData.x=x(:,[tr.testInd tr.valInd]);
    TestData.t=t(:,[tr.testInd tr.valInd]);
    TestData.y=y(:,[tr.testInd tr.valInd]);
    TestData.e=e(:,[tr.testInd tr.valInd]);
    if ~isempty(x)
        TestData.E=perform(net,TestData.t,TestData.y);
    else
        TestData.E=inf;
    end
    
    % Export Results
    if ~isempty(x)
        results.net=net;
    else
        results.net=[];
    end
    results.Data=Data;
    results.TrainData=TrainData;
    % results.ValidationData=ValidationData;
    results.TestData=TestData;
    
end