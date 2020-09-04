function[y]=array_factor(x1,phi)
%As the function name signifies here the array factor is calculated
global  dim pi
  y=0;
  for i=1:dim
  y=y+cos(pi*x1(i)*cos(phi));
  end;
  y=y*2;
  y=realpow(y,2);
 
