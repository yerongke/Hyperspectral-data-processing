%导入数据Xcal,Ycal,f,Xtest,Ytest
Xcal=Xcal';
Xtest=Xtest';
dataset=[Xcal Ycal];
f=f(:,1);
var=dyn_bipls(dataset,15,20,400);
Model=ipls(Xcal,Ycal,15,'mean',20,f,'syst123',5);
oneModel=plsmodel(Model,[2 11],15,'mean','syst123',5);
plspvsm(oneModel,5)
plspvsm(oneModel,6)
plspvsm(oneModel,8)
plspvsm(oneModel,10)
plspvsm(oneModel,12)
plspvsm(oneModel,9)
Model
Model.allint

X=[Xcal(:,79:156),Xcal(:,391:468),Xcal(:,937:1014),Xcal(:,1404:1480),Xcal(:,1481:1557)];
whos X
dataset1=[X Ycal];
[b,fin,sel]=gapls(dataset1,100);
whos b
whos fin
whos sel
b
sel
fin
plot(fin(1,:),fin(4,:))
ss=b(1:58);
XX=X(:,ss);
whos XX

Model=ipls(XX,Ycal,9,'mean',1,1:58,'syst123',5);
plspvsm(Model,9,1)
oneModel=plsmodel(Model,1,9,'mean','syst123',5);
Y=[Xtest(:,79:156),Xtest(:,391:468),Xtest(:,937:1014),Xtest(:,1404:1480),Xtest(:,1481:1557)];
YY=Y(:,ss);
predModel=plspredict(YY,oneModel,9,Ytest);
plspvsm(predModel,9)

