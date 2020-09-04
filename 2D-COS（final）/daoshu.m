 A=[];%产生一个空矩阵
for i=1:3
data=zeros(451,1);%生成一个行*列为1557*1的零矩阵     
    s=strcat('0-',num2str(i),'.txt');%'-'是取得i和j之间的链接符。如果是1.2那就是'.'。
    k=importdata(s);
    t=k(:,2);%如果原数据的第一列是光的波数，第二列才是吸光度，那么这里写2
    data=data+t;
data=data/3;
    A=[A,data];
    B=sum(A,2);
end