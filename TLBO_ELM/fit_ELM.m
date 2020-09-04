function  CCR=fit_ELM(X1,Y1,X2,Y2,C)
          X1=X1';
          Y1=Y1';
          X2=X2';
          Y2=Y2';
         
          [IW,B,LW,TF,TYPE] = elmtrain(X1,Y1,C,'sig',1);
          T_sim_1 = elmpredict(X2,IW,B,LW,TF,TYPE);
          k1 = length(find(Y2 == T_sim_1));
          n1 = length(Y2);
          CCR= n1 / k1 ;%取倒数方便用min寻优，max也可以，min方面一点，还可以用sort排序之后要第一行
%CCR=mse(T_sim_1-Y2);