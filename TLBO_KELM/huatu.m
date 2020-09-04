load C_1.mat
load SA_1.mat
load RF_1.mat

pp=1:1:30;
pp=pp';
figure;
%plot(BestCost,'LineWidth',2);
%plot(BestCost,'b-o');
plot(pp,C_1,'-mp','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[0.5,0.5,0.5])
hold on
plot(pp,SA_1,'-ms','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor',[0.5,0.5,0.5])
hold on
plot(pp,RF_1,'-md','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5])
axis([0,30,1.13,1.35]);
xlabel('Iteration');
ylabel('Best fitness value');
legend('CARS','SA','RFA')