function[y]=functional_value(x1)
%This function calculates the fitness value of array 'x1' which is returned in 'y'
global phi_l phi_u null num_null num pi 
y=0;
for i=1:num%In this loop the objective function for 
    %side lobe level suppresion is calculated
    %num denotes the number of SLLs
del=phi_u(i)-phi_l(i);%del denotes the angular span of 
del=del*(180/pi);%the ith SLL
  t=trapezoidal(x1,phi_u(i),phi_l(i),100);%For performing integration
  %the trapezoidal method is used
  t=t/del;
  y=y+t;
end;
y1=0;
for i=1:num_null%The objective function for null control
    %is calculated here
    y1=y1+array_factor(x1,null(i));
end;
y=y1+y;