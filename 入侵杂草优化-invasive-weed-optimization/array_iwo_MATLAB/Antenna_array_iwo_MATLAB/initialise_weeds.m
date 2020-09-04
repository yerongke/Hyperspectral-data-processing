function x=initialise_weeds(n)
%This funcction initializes the weeds 
%n denotes the number of weeds
global dim
x=rand(n,dim);
for i=1:n
    for j=1:dim
         x(i,:)=(i-1)*rand(1,dim)*.05+x(i,:);
    end;
end;