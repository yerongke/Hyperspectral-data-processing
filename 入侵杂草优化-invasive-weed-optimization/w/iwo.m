%主函数
%****参数定义区域（以下）********
clc;
clear;
seeddim=8;%初始化维数
initseednum=10;%初始化种子个数
Pmax=20;%种群最大数量值
maxseed=4;%产生最多种子数
xmax=1;%初始化最大X值
xmin=0;%初始化最小X值
iter_max=100;%最大迭代次数
iter=1;%初始化迭代次数
%****参数定义区域（以上）********
x=xmin+(xmax-xmin)*rand(seeddim,initseednum);
Sum=initseednum;
directva=[];
while iter<=iter_max
    for i=1:Sum
        seed_num=fix(maxseed-maxseed*direct(x(:,i))/4);
        if seed_num<0
            break;
        end
        sd=normrnd(0,acur(iter,iter_max),[seeddim seed_num]);
        for j=1:seed_num
            temx=x(:,i)+sd(:,j);
            temx(temx<xmin)=xmin;
            x=[x temx];
        end
    end
    Sum=length(x(1,:));
    if Sum>Pmax
        Fit_tem1=[];
        for i=1:Sum
            Fit_tem1=[Fit_tem1 direct(x(:,i))];
        end
        Fit_tem2=sort(Fit_tem1);
         directva=[directva Fit_tem2(1)];
        x_tem=x;
        for i=1:Sum
            for j=1:Sum
                if Fit_tem2(i)==Fit_tem1(j)
                   x_tem(:,i)=x(:,j);
                end
            end
        end
        x=x_tem;
        x(:,[Pmax+1:Sum])=[];
        Sum=Pmax;
    end
    iter=iter+1;
    iter
end