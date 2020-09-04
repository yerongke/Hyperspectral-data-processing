function[q]=trapezoidal(x2,upper,lower,N1)         
%This function performs integration by trapezoidal rule
h=(upper-lower)/N1;
 x1=lower;
 y=array_factor(x2,lower);
 for i=2:N1+1
 
  x1=x1+h;
  y(i)=array_factor(x2,x1);
 end;
s=0;
 for i=1:N1+1
 
  if(i==1||i==N1+1)
	s=s+y(i);
  else
	s=s+2*y(i);
  end;
 end;
 q=(h/2)*s;

 
 




  




