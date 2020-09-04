function data=InsertData()
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


data=[inputs targets];
% [data,psdata]=mapminmax(data');
% data=data';
% [~,psy]=mapminmax(targets');


n_column_input=size(inputs,2);


ndata=size(data,1);

n_column_output=size(targets,2);

R=randperm(ndata);
data=data(R,:);

ntrain=round(ndata*ptrain);


traindata=data(1:ntrain,:);
testdata=data(ntrain+1:end,:);


trainX=traindata(:,1:n_column_input)';
trainY=traindata(:,n_column_input+1:end)';


testX=testdata(:,1:n_column_input)';
testY=testdata(:,n_column_input+1:end)';

hiddenlayers=5;



net = newff(trainX,trainY,hiddenlayers,{'tansig','tansig','tansig'});
view(net)



info.trainX=trainX;
info.trainY=trainY;

info.testX=testX;
info.testY=testY;

info.net=net;

info.nIW=numel(net.IW{1,1});
info.nLW=numel(net.LW{2,1});
info.nb1=numel(net.b{1,1});
info.nb2=numel(net.b{2,1});

nvar=info.nIW+info.nLW+info.nb1+info.nb2;

save data
data=load('data.mat');

end