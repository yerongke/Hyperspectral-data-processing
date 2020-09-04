function clamp_antenna(i)
% 
% checks whether the Weeds/seeds are within the search space or not.
% if not,they are clamped 
% otherwise they are left as they are
% returns no value
global x dim

for t=1:dim
    if x(i,t)<0 
        x(i,t)=0;
    end;
    if x(i,t)>dim 
        x(i,t)=dim-.00001;
    end;
end;


        
