% PLSC 
% Data Scaling
% sintax:
% [x]=sc_ga(x,mx,sx);

function[x]=sc_ga(x,mx,sx);

[rx,cx]=size(x);

x=(x-ones(rx,1)*mx)./(ones(rx,1)*sx);

% INPUT DATA
% aut=0 Original Data 		mx=zeros(1,cx)  		sx=ones(1,cx)
% aut=1 Column Centering 	mx=vector of mean terms		sx=ones(1,cx)
% aut=2 Autoscaling		mx=vector of mean terms  	sx=vector of standard deviations
