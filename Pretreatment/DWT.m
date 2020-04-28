function x=DWT(xyuan)

%获取输入信号的长度特征
sizex=size(xyuan);
row=sizex(1);
column=sizex(2);

%定义返回矩阵,即小波变换后的矩阵
x=zeros(row,column);

%定义小波变换滤波中的参数
wname='bior3.3';  %选择小波函数名
lev_max=wmaxlev(row,wname)
lev=5      %设定分解层数

for i=1:column
    %小波分解,得出小波分解结构[c,l]
    [c,l]=wavedec(xyuan(:,i),lev,wname); 
 
    %阈值选择、信号去噪、信号重构
    
    %基于原始信号噪声强度的阈值选取
     % 一、缺省的阈值模型
%     [thr1,sorh,keepapp]=ddencmp('den','wv',xyuan(:,i));    %根据传入的信号xyuan得到降噪的各级阈值
%      keepapp=1;
%      xd=wdencmp('gbl',c,l,wname,lev,thr1,'s', keepapp);   %重建降噪后的信号
%      x(:,i)=xd;    %将每条光谱信号合并为去噪后的光谱矩阵
     
    % 二、Brige-Massart策略所确定的阈值
    alpha=3;   %选择参数a    
    [thr2,nkeep]=wdcbm(c,l,alpha);    %使用Brige-Massart策略确定阈值
    keepapp=1;
    xd=wdencmp('lvd',c,l,wname,lev,thr2,'s');   %重建降噪后的信号
    x(:,i)=xd;    %将每条光谱信号合并为去噪后的光谱矩阵
   
    %三、penalty策略所确定的阈值
%     s=xyuan(:,i)';  %wbmpen只能处理行向量，因此需对列进行转置
%     [c0,l0]=wavedec(s,lev,wname);  %行向量小波分解
%     alpha=2;
%     keepapp=1;
%     sigma=wnoisest(c0,l0,1);    %通过第一层的细节系数估算信号的噪声强度
%     thr3=wbmpen(c0,l0,sigma,alpha);   %使用penalty策略确定阈值
%     [xd,cxd,lxd,perf0,perfl2]=wdencmp('gbl',c,l,wname,lev,thr3,'s', keepapp);   %重建列向量降噪后的信号
%     x(:,i)=xd;    %将每条光谱信号合并为去噪后的光谱矩阵
     
     %基于样本估计的阈值选取
     % 四、主要包括四种规则：
     %                    'rigrsure',stein无偏似然估计规则
     %                    'sqtwolog',对数长度统一阈值规则
     %                    'heursure',启发式sure阈值规则
     %                    'minimaxi',最小极大方差阈值规则
%      tptr='minimaxi';         %选择阈值选取规则    
%      s=xyuan(:,i)';
%      thr4=thselect(s,tptr);
%      keepapp=1;
%      [xd,cxd,lxd,perf0,perfl2]=wdencmp('gbl',c,l,wname,lev,thr4,'s', keepapp);   %重建降噪后的信号
%      x(:,i)=xd;    %将每条光谱信号合并为去噪后的光谱矩阵
     
    %五、直接使用近似系数进行重构
    
%     ca=wrcoef('a',c,l,wname,lev);     %重建第lev层的近似系数
%     x(:,i)=ca;                      %直接将其作为降噪信号
    
end
  %   画出原始信号和降噪后的信号
       % figure,subplot(2,1,1),plot(xyuan(:,3)),title('原始信号');
        %       subplot(2,1,2),plot(x(:,3)),title('降噪后的信号');   
    
    