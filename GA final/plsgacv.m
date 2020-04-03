% PLSC 
% Computation of Cross-Validated Explained Variance
% after predictors selection using genetic algorithms 
% sintax:
% [best,exp_var_cv,mxi,sxi,myi,syi]=plsgacv(x,y,aut,ng,A,msca,ssca);

function[best,exp_var_cv,mxi,sxi,myi,syi]=plsgacv(x,y,aut,ng,A,mxi,sxi,myi,syi);

mx=[];sx=[];
if nargin==5;
	mxi=[];sxi=[];
	myi=[];syi=[];
	in=1;
elseif nargin==7
	in=2;
	myi=[];syi=[];
else
	in=0;
end

[rx,cx]=size(x);
if cx<A
  A=cx;
end 

ypred=zeros(1,A);

for nga=1:ng;

 	vcg=(nga:ng:rx);
 	xcg=x(vcg,:);
 	ycg=y(vcg,:);
 	xrid=x;yrid=y;
 	xrid(vcg,:)=[];
 	yrid(vcg,:)=[];
	if in>0;
		if aut==0;
			if in==1;
				mx=zeros(1,cx);sx=ones(1,cx);
			end
			my=0;sy=1;
		elseif aut==1;
			if in==1;
				mx=mean(xrid);sx=ones(1,cx);
			end
			my=mean(yrid);sy=1;
		elseif aut==2;
			if in==1;
				mx=mean(xrid);sx=std(xrid);
			end
			my=mean(yrid);sy=std(yrid);
		end
     
      mxi=[mxi;mx];sxi=[sxi;sx];	
		myi=[myi;my];syi=[syi;sy];		
	end
 	[xrid]=sc_ga(xrid,mxi(nga,:),sxi(nga,:));
 	[yrid]=sc_ga(yrid,myi(nga,:),syi(nga,:));
 	varinx=sum(xrid.^2);
 	variny=sum(yrid.^2);

 	% Computing regression parameters on the training set 
 	[wmat,umat,pmat,cmat,dvet,pnorm]=reg_ga(xrid,yrid,A);

 	% Computing response values on the evaluation set 
 	[xcg]=sc_ga(xcg,mxi(nga,:),sxi(nga,:));
 	ypr=Pr_ga(xcg,wmat,pnorm,pmat,cmat,dvet,A,syi(nga,:),myi(nga,:));
 	ypred(vcg,:)=ypr;

end;

if in>0;
	if aut==0;
		myi=[myi;0];syi=[syi;1];		
	elseif aut==1;
		myi=[myi;mean(y)];syi=[syi;1];		
	elseif aut==2;
		myi=[myi;mean(y)];syi=[syi;std(y)];		
	end
end


[yt]=sc_ga(y,myi(ng+1),syi(ng+1));
variny=sum(yt.^2);
[best,exp_var_cv]=Err_ga(y,ypred,A,syi(ng+1),variny);

if exp_var_cv<0
  exp_var_cv=0;
end
