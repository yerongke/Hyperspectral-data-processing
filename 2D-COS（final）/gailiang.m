fig_num=0;%这个和后面那句figure(fig_num*2+1);一起时用来给图命名的。
clear N asynch tran_data_x tran_data_y c_end c_star data_x data_y i ...
    mean_data_x mean_data_y clear n_x n_y synch x y  c_x x_select ...
    y_select c_y globel x_label y_label jiange n;

pre_data=B;%dadou是自己的文件名

select_star_n=800;     %  选择起点(波长)
select_end_n =420;     %  选择终点(波长)
 
[r,c]=size(pre_data);
i=1;
while i<c+1
    if pre_data(1,i)<select_star_n
        select_star=i-1;
        i=c;
    end
    i=i+1;
end

j=select_star+1;
while j<c+1
    if pre_data(1,j)<select_end_n
        select_end=j;
        j=c;
    end
    j=j+1;
end


data_x=pre_data(:,select_star:select_end);
data_y=pre_data(:,select_star:select_end);%x轴和y轴都是波长

%平均变换
[n_x,c_x]=size(data_x);
n_x=n_x-1;
mean_data_x=mean(data_x(2:n_x+1,:));  %第二行到第n+1行所有列的数据
for i=1:n_x
    tran_data_x(i,:)=data_x(i+1,:)-mean_data_x;
end

[n_y,c_y]=size(data_y);
n_y=n_y-1;
mean_data_y=mean(data_y(2:n_y+1,:));
for i=1:n_y
    tran_data_y(i,:)=data_y(i+1,:)-mean_data_y;
end

n=n_x;

%  Hilbert_Noda
N = zeros(n);
for i=2:(n)
    N(1,i) = 1/(pi * (i-1));
end
for i=2:(n-1)
    for j=i:(n)
        N(i,j) = N(i-1,j-1);
    end;
end
for i=2:(n)
    for j=1:i
        N(i,j) = -N(j,i);
    end;
end
clear i j

x_label='波长/nm';
y_label='波数/nm';


%%相关分析
[x,y]=meshgrid(data_x(1,1):(data_x(1,c_x)-data_x(1,1))/(c_x-1):data_x(1,c_x),...
    data_y(1,1):(data_y(1,c_y)-data_y(1,1))/(c_y-1):data_y(1,c_y));
synch=tran_data_y(:,1:c_y)'  *tran_data_x(:,1:c_x) /(n-1);
asynch=tran_data_y(:,1:c_y)' * N * tran_data_x(:,1:c_x)/(n-1);
asynch=-1.*asynch;
globel=asynch./synch;
%绘图  产生4个图形

contour_n=32;%等高线高度
figure(fig_num*2+1);%图1
contourf  (x, y,synch,contour_n, 'DisplayName', 'x, y,synch');%同步图（彩色）
xlabel(x_label);
ylabel(x_label);
title('同步图');
Draw_for_2d;
 
 
figure(fig_num*2+2);%图2
contourf (x, y,asynch,contour_n, 'DisplayName', 'x, y,asynch');%异步图（彩色）
xlabel(x_label);
ylabel(x_label);
title('异步图');
Draw_for_2d;

figure(fig_num*2+3);%图3
for m=1:c_x
    xx(m)=x(m,m);
    zz(m)=synch(m,m);
end
plot(xx,zz);
xlabel(x_label);
title('自动峰强度曲线图');

figure(fig_num*2+4);
cut_a(1,1:2)=[450,450];
n=1;
for i=1:c_x
    for j=1:c_x
        if synch(i,j)>100
            n=n+1;
            cut_a(n,1:2)=[x(i,j),y(i,j)];
            
        end
    end
end
scatter(cut_a(:,1),cut_a(:,2));
xlabel(x_label);
ylabel(x_label);
 title('横截面图');%同步图的横截面积

clear c r select_end select_star select_end_n select_star_n...
    N asynch tran_data_x tran_data_y c_end c_star data_x data_y i ...
    mean_data_x mean_data_y clear n_x n_y synch x y  c_x x_select ...
    y_select c_y globel x_label y_label jiange n;