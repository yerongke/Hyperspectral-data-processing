function sol=fitness(sol,data)

info=data.info;

x=sol.x;
net=info.net;

IW=x(1:info.nIW);
IW=reshape(IW,size(net.IW{1,1}));
x(1:info.nIW)=[];

LW=x(1:info.nLW);
LW=reshape(LW,size(net.LW{2,1}));
x(1:info.nLW)=[];


b1=x(1:info.nb1);
b1=reshape(b1,size(net.b{1,1}));
x(1:info.nb1)=[];

b2=x(1:info.nb2);
b2=reshape(b2,size(net.b{2,1}));


net.IW{1,1}=IW;
net.LW{2,1}=LW;
net.b{1,1}=b1;
net.b{2,1}=b2;
trainX=info.trainX;
trainY=info.trainY;

trainO=net(trainX);
trainErrors=trainY-trainO;
Z=mean(trainErrors(:).^2);

sol.fit=Z;
sol.info.net=net;




end