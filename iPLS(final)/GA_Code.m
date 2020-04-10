function  [vars] = GA_Code(boshudian, n_Vars)
%%本函数的功能是把近红外光谱波长划分为n_Vars个区间，并记录每个区间的波数位置
%%Input
%%  boshudian: 1 * n维 
%%生产解码数组
vars = zeros(n_Vars, 2);
[m_boshu, n_boshu] = size(boshudian);
%%计算每个区间的基本宽度
Width_base = floor(n_boshu/n_Vars);
%%判断区间个数设置是否合理
if n_Vars > n_boshu
   disp(' ')
   disp('参数设置错误，区间数不能大于波数点数，程序退出')
   disp(' ')
   return
end
%%计算剩余的波数点数
More_waves = n_boshu - Width_base*n_Vars;
%%将多余的波数点数平均分给前More_waves个区间，每个区间在基本宽度的基础上再加1个波数点
if More_waves 
    w1 = Width_base + 1;    %前More_waves个区间包含的波数点数
    w2 = Width_base ;      %其余区间包含的波数点数
else
    w2 = Width_base ;      %其余区间包含的波数点数
end
%%计算每个区间的其实波数点和结束波数点

if More_waves       %%如过存在多余的波数点
    for i = 1: More_waves
        vars(i, 1) = (i - 1)*w1 + 1;
        vars(i, 2) = i*w1;
    end
    for j = More_waves + 1 : n_Vars
        vars(j, 1) = (j - 1)*w2 + 1 + More_waves;
        vars(j, 2) = j*w2 + More_waves;
    end
else            %%如果不存在多余的波数点
    for i = 1:n_Vars
        vars(i, 1) = (i - 1)*w2 + 1; 
        vars(i, 2) = i*w2;
    end
end

end