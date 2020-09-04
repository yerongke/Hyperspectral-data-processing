function Z=CalError(out,yp,Name)
out=reshape(out,[],1);
yp=reshape(yp,[],1);
C=corrcoef(out,yp);
compar=sign([[diff((out))] [diff((yp))]]);
compar=sum(compar,2);
f=length(find(abs(compar)==2));
MSE=mse(yp-out);
RMSE=sqrt(MSE);
MAE=mean(abs((out)-(yp)));
MAPE=mean(abs((out)-(yp))./abs(yp));
R=C(1,2);
SCP=f/length((out))*100;
disp(['====== For ' Name ' ====='])
disp(['R2 =' num2str(R)])
disp(['MSE =' num2str(MSE)])
disp(['RMSE =' num2str(RMSE)])
disp(['MAPE =' num2str(MAPE)])
disp(['MAE=' num2str(MAE)])
% disp(['SCP=' num2str(SCP)])
Z=[ MSE RMSE  MAE MAPE R SCP];


end