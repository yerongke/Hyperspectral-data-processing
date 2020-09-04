function ShowResults(net)

load data
trainO=net(trainX);
trainErrors=trainY-trainO;
trainMSE=mean(trainErrors(:).^2);
trainRMSE=sqrt(trainMSE);
trainErrorMean=mean(trainErrors);
trainErrorStd=std(trainErrors);
disp('-----------------------------------------')
disp([ ' Train MSE = '  num2str(trainMSE)]);
disp('-----------------------------------------')


testO=net(testX);
testErrors=testY-testO;
testMSE=mean(testErrors(:).^2);
testRMSE=sqrt(testMSE);
testErrorMean=mean(testErrors);
testErrorStd=std(testErrors);

disp([ ' Test MSE = '  num2str(testMSE)]);
disp('-----------------------------------------')


figure;PlotResults(trainY,trainO,'train');
figure;PlotResults(testY,testO,'test');

inputs=data(:,1:n_column_input)';
targets=data(:,n_column_input+1:end)';
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)
trainInd=tr.trainInd;
trainInputs = inputs(:,trainInd);
trainTargets = targets(:,trainInd);
trainOutputs = outputs(:,trainInd);
trainErrors = trainTargets-trainOutputs;

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs)
valPerformance = perform(net,valTargets,outputs)
testPerformance = perform(net,testTargets,outputs)
valInd=tr.valInd;
valInputs = inputs(:,valInd);
valTargets = targets(:,valInd);
valOutputs = outputs(:,valInd);
valErrors = valTargets-valOutputs;
testInd=tr.testInd;
testInputs = inputs(:,testInd);
testTargets = targets(:,testInd);
testOutputs = outputs(:,testInd);
testError = testTargets-testOutputs;



PlotResults(targets,outputs,'All Data');
PlotResults(trainY,trainO,'Train Data');
PlotResults(testY,testO,'Test Data');

CalError(targets,outputs,'All Data');
CalError(trainY,trainO,'Train Data');
CalError(testY,testO,'Test Data');


Q=[];
disp('======================')
disp('Forecast')
disp('======================')
for i=1:nPredict
   j=Ndata+i; 
   xpred=inputs(:,end-i+1); 
%    ypred(i)=mapminmax('reverse',net(xpred(:,i)),PS);
    ypred=net(xpred);
%     ypred=mapminmax('reverse',ypred',psy)';

   disp(['step ' num2str(j) ' = ' num2str(ypred)])
    [Q]=[Q;[j ypred]];
end



end