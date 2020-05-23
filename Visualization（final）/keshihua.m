
%% 获取像素矩阵
img = imread('1.jpg');  % 读取图片
i = rgb2gray(img);          % 转为灰度图片
level = graythresh(i);     % 自动选择转换为二值图像的阈值
b=imbinarize(i,level);     % 图像二值化
%I2 = im2bw(img, 0.64);%手动设置阈值
imshow(b);
xlswrite('D:\data.xlsx',b);

%% 像素颜色选择  http://blog.sina.com.cn/s/blog_90d14ed60102uys9.html
%mycolor7 = [0 0 0;1 0 0;1 0.3804 0;1 1 0;0 1 0;0.47 0.67 0.19;0 0 1;0.4787 0.0627 0.8941];
mycolor7 = [1 1 1;0.14 0 0;0.28 0 0;0.42 0 0;0.56 0 0;0.7 0 0;0.84 0 0;0.98 0 0];%由黑到红
mycolor7 = [1 1 1;0 0 0.98;0 0 0.84;0 0 0.7;0 0 0.56;0 0 0.42;0 0 0.28;0 0 0.14];%由蓝到黑
mycolor7 = [1 1 1;0.98 0 0;0.84 0 0;0.7 0 0;0.56 0 0;0.42 0 0;0.28 0 0;0.14 0 0];%由红到黑
mycolor7 = [1 1 1;0 0.98 0;0 0.84 0;0 0.7 0;0 0.56 0;0 0.42 0;0 0.28 0;0 0.14 0];%由绿到黑

%% 像素矩阵合并
a=xlsread('1.xlsx');
b=xlsread('2.xlsx');
c=xlsread('3.xlsx');
d=xlsread('4-.xlsx');
e=xlsread('5.xlsx');
f=xlsread('6.xlsx');
g=xlsread('7-.xlsx');
l=max([length(a),length(b),length(c),length(d),length(e),length(f),length(g)]);

H=[padarray(a,[l-length(a) 0],'post') padarray(b,[l-length(b) 0],'post') padarray(c,[l-length(c) 0],'post') padarray(d,[l-length(d) 0],'post') padarray(e,[l-length(e) 0],'post') padarray(f,[l-length(f) 0],'post') padarray(g,[l-length(g) 0],'post')];
%H就是讲矩阵合并，将行数小的矩阵补零，凑成行数一致，matlab中扩充矩阵的函数padarray
imagesc(H);
colormap(mycolor7);
colorbar;
caxis([0 7])
%imshow(b);				   % 显示图片

I=imread('1.jpg');
I1=rgb2gray(I);
level=graythresh(I1);
I2=im2bw(I1,level);
I3=~I2;
I4=bwareaopen(I3,50);
I5=~I4;
figure,imshow(I5)






I=imread('1.tif');
figure,imshow(I)