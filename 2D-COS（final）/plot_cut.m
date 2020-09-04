
cut_a(1,1:2)=[450,450];
n=1;
for i=1:372
    for j=1:372
        if synch(i,j)>1500
            n=n+1;
            cut_a(n,1:2)=[x(i,j),y(i,j)];
            
        end
    end
end
scatter(cut_a(:,1),cut_a(:,2));
xlabel(x_label);
ylabel(x_label);