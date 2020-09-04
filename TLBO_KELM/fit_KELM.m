function  CCR=fit_KELM(X1,Y1,X2,Y2,C,g)
          
          [~, ~, ELM_Kernel_Model]=elm_kernel_train(X1,Y1,7,1,C, 'RBF_kernel',g);
          [~, T_sim_1] = elm_kernel_predict(X2, X1, ELM_Kernel_Model);
          Y2=Y2';
          k1 = length(find(Y2== T_sim_1));
          n1 = length(Y2);
          CCR= n1 / k1 ;%取倒数方便用min寻优，max也可以，min方面一点，还可以用sort排序之后要第一行
%CCR=mse(T_sim_1-Y2);