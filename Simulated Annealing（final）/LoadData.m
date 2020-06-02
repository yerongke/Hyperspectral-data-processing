
function data=LoadData()

    load('SNV.mat');
    SNV=SNV(1:315,:)';
    data.x=SNV(1:254,:);
    data.t=SNV(255,:);
    
    data.nx=size(data.x,1);
    data.nt=size(data.t,1);
    data.nSample=size(data.x,2);

end