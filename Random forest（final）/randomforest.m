data=[];
a = randperm( );  %填写总数据数量
Train = data(a(1:20),:); %取1到20行为训练集
Test = data(a(21:end),:);  %剩下的为测试集
% 训练数据
P_train = Train(:,2:end);
T_train = Train(:,1);
% 测试数据
P_test = Test(:,2:end);
T_test = Test(:,1);
%% 创建随机森林分类器
model = classRF_train(P_train,T_train);
%% 仿真测试
[T_sim,votes] = classRF_predict(P_test,model);
%%获得随机森林
ctree=ClassificationTree.fit(P_train,T_train);
%%随机森林试图
 view(ctree);
view(ctree,'mode','graph');

%%十字交叉验证
leafs=logspace(1,2,10);
N=numel(leafs);
err=zeros(N,1);
for n=1:N
t=ClassificationTree.fit(P_train,T_train,'crossval','on','minleaf',leafs(n));
err(n)=kfoldLoss(t);
end
plot(leafs,err);
