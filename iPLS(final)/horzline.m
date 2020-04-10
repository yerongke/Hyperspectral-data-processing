function horzline(place,color)
%  horzline puts a horizontal line at a given value(s)
%  hline(1.4,'--b'); plots a horizontal dashed
%  blue line at place = 1.4. If no input arguments are given,
%  hline will draw a horizontal green line at 0.
%
%  horzline(place,color)

if nargin == 0
  place = 0;
end  
if nargin<2
  color = '-k';
end
[n,m] = size(place);
if m>1
  place = place';
  n = m;
end

v = axis;
if ishold
  for i=1:n
    plot(v(1:2),[1 1]*place(i,1),color);
  end
else
  hold on
  for i=1:n
    plot(v(1:2),[1 1]*place(i,1),color);
  end
  hold off
end
