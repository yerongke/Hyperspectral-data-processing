for i=1:3
DataFileName1=strcat('czA-',num2str(i),'.txt');
data1=load(DataFileName1);
you(:,i)=data1(:,2)';
end