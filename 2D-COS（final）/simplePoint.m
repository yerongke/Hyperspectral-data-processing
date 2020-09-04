B=[];%产生一个空矩阵
for i=1:12 %
data=zeros(8,1);%生成一个行*列为396*1的零矩阵     
for j=1:3
    s=strcat(num2str(i),'-',num2str(j),'.txt');%'-'是取得i和j之间的链接符。如果是1.2那就是'.'。
    k=importdata(s);
    alldata=k.data;
    C = alldata(:,5)./alldata(:,4);
    %t=k(:,2);%如果原数据的第一列是光的波数，第二列才是吸光度，那么这里写2
    data=data+C;
end
    data=data/3;
    B=[B,data];
end