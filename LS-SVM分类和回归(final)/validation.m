function [yhat,e] = validation(Xcal,ycal,Xval,yval,var_sel)

% [yhat,e] = validation(Xcal,ycal,Xval,yval,var_sel) --> Validation with a separate set  用单独的集合验证
% [yhat,e] = validation(Xcal,ycal,[],[],var_sel) --> Cross-validation [yhat，e]=验证（xcal，ycal，[]，[]，var sel）-->交叉验证

N = size(Xcal,1); % Number of objects in the calibration set
NV = size(Xval,1); % Number of objects in the validation set

if NV > 0 % Validation with a separate set
    Xcal_ones = [ones(N,1) Xcal(:,var_sel)];
    b = Xcal_ones\ycal; % MLR with offset term (b0)
    yhat = [ones(NV,1) Xval(:,var_sel)]*b; % Prediction over the validation set
    e = yval - yhat; % Validation error
else % Cross-validation    
    yhat = zeros(N,1); % Setting the proper dimensions of yhat
	for i = 1:N
       % Removing the ith object from the calibration set
       cal = [[1:i-1] [i+1:N]];
       X = Xcal(cal,var_sel);
       y = ycal(cal);
       xtest = Xcal(i,var_sel);
       ytest = ycal(i);
       X_ones = [ones(N-1,1) X];
       b = X_ones\y; % MLR with offset term (b0)
       yhat(i) = [1 xtest]*b; % Prediction for the ith object 第i个物体的预测
   end
    e = ycal - yhat; % Cross-validation error 交叉验证错误
end