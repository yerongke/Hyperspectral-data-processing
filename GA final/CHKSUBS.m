% function chksubs cheks subsets
function [a,b]=chksubs(cr,crom,s)
a=[];
b=[];
cmat=ones(cr,1)*s;
d=cmat-crom;
cmat2=(d==1);
v2=sum(cmat2');
a=find(v2==0); % a contains the list of the chromosomes of which s is a subset
cmat2=(d==-1);
v2=sum(cmat2');
b=find(v2==0); % b contains the list of the chromosomes that are a subset of s
