function iwoantenna
%------------IWO algorithm------------------------------------------
%
%      1.   Initialisation,find best and worst fitness
%      2.   Create offsprings
%      3.   Spread them in normal distribution with 
%                    standard deviation,determined by the described function
%      4.   If no. of plants >= max_plants
%                 eliminate higher fitness plants.
%      5.   Continue.........
%--------------------
%---FUNCTION DESCRIPTION--------------------------------------------
%1.iwoantenna                main function
%2.initialise_weeds          function that initialises population at the beginning of
%                          each run
%3.functional_value          calculates fitness of plant
%4.clamp_antenna             The weed or seed is clamped if it crosses the
%                          search space
%5.array_factor              The array factor is calculated
%6.trapezoidal               Here integration is performed by trpaezoidal
%                          rule
%---------------------
global x dim choice 
global phi_l phi_u null num_null num pi 
pi=3.141592654;
choice=11;
 %------------USER INPUT----------------------------------------------
no_runs=input('Enter number of runs:');
no_iter=input('Enter number of iterations in each run:');
dim=input('Enter the number of dimensions :');
num=input('Enter no. of SLLs:');
for i=1:num
temp=input('enter upper limit:');
phi_u(i)=(pi/180)*temp;
temp=input('enter lower limit:');
phi_l(i)=(pi/180)*temp;
end;
num_null=input('enter number of null placements:');
for i=1:num_null
temp=input('enter null angle:');
null(i)=(pi/180)*temp;
 end;

%------------------INITIALIZATION OF PARAMETERS--------------------------

U=100;
no_agents=10*dim;
s_ini=1;%initial standard deviation of seeds
s_fin=.000000000000001;%final standard deviation of seeds
fe=0;
maxfe=5000000;
n_m_i=3;   % nonlinear modulation index that controls the change of 
%standard deviation with which seeds are produced
max_pl = 20*dim;            
max_seed=5;
%-----------MAIN PROGRAM STARTS------------------------------------------
for runs=1:no_runs    %This is the loop of the master runs   
INDEX=no_agents;
fe=0;
x=initialise_weeds(no_agents);%In this function weeds are intialized
U=100;%U stores the best functional value obtained
   for i=1:INDEX
       
       f=functional_value(x(i,:));
       y(i)=f;
       fe=fe+1;
           if f <U
               U=f;
               gbest=x(i,:);%The array gbest stores the best antenna array obtained 
           end     
   end

  for t=1:no_iter

  w_fit=max(y);
  b_fit=min(y);
  s=((no_iter-t)^n_m_i)/(no_iter^n_m_i);
  s=s*(s_ini-s_fin)+s_fin;%here the standard deviation is calculated
  ind=0;
 

 for i=1:INDEX %The index i denotes the weed no. which are considered one at a time 
      
      if (w_fit-b_fit)==0 %If the program converges then the best and worst fitness will be the same
            display('all same');%This might also happen if the standard deviation is very less
            break;
        end
        
        n=max( floor((max_seed*(w_fit-y(i))/(w_fit-b_fit))), 0);%here the number of seed that the
        %plant should produce is calculated
      if n>max_seed
       n=max_seed;
      end;
      ind1=ind;
      ind=ind+n;
      

    for se=INDEX+ind1+1:INDEX+ind %In this loop the ith plant produces n seeds 
        %which are stored in array x
        for j= 1:dim
             r = randn*s;
             x( se,j) =x(i,j) +r;
        end  
       clamp_antenna(se);%this function clamps the seeds if they move out of the search space
       f = functional_value(x(se,:)); 
       fe=fe+1;
           if f <U%Update of U and gbest are performed if better solution is found
               U=f;
               gbest=x(se,:);
           end
       y(se)=max(U,f);
       
         

     end     % next se

  end      % next i
  INDEX=INDEX+ind;
  %INDEX denotes the number of seeds and plants combined
  %This might exceed the maximum number of plants allowed
  %Now we take the best solutions from the population 
  %--------------------------------------------------------
  
  for i=1:INDEX  %population is sorted according to their fitness values
       for j=i+1:INDEX
           if y(i)>y(j)
               temp=y(i);
               y(i)=y(j);
               y(j)=temp;
               temp2=x(i,:); 
               x(i,:)=x(j,:);
               x(j,:)=temp2;
           end;
       end;
   end;
  INDEX=max_pl;
  if fe>maxfe
      break;
  end;
 
  
  
  
  
  end%---------------next iteration-------------------------------
min1=U;
best=1;
for i=1:max_pl
     z=functional_value(x(i,:));
      if z<min1
          min1=z;
          gbest=x(i,:);
      end
end
gbest=sort(gbest);
fprintf('RUN:%d\n',runs);
gbest
bestruns(runs,:)=gbest;%The best solution is stored for further satistical calculations
fprintf('cost:%f\n',functional_value(gbest));
end;
%---END OF IWO ALGORITHM--------------------------------------------------


for i=1:no_runs%The best functional values of each run is stored in array 'values'
    values(i)=functional_value(bestruns(i,:));
end;
%---------Calculation of mean---------------------
sum=0;
for i=1:no_runs
    sum=sum+values(i);
end;
mean=sum/no_runs;
fprintf('mean:%f\n',mean);
%-------------------------------------------------
%---------Calculation of standard deviation-------
sum=0;
for i=1:no_runs
    sum=sum+realpow(values(i)-mean,2);
end;
sum=sqrt(sum);
stdev=sum/no_runs;
fprintf('standard deviation:%f\n',stdev);
%-------------------------------------------------

%--------Extraction of median solution------------
values=sort(values);
median=ceil(no_runs/2);
for i=1:no_runs
    if functional_value(bestruns(i,:))==values(median)
        m_pos=i;
    end;
end;
gbest=bestruns(m_pos,:);
fprintf('median solution:\n');
for i=1:dim
    fprintf('%f    ',gbest(i));
end;
fprintf('\n');
%--------------------------------------------------

%------The median solution is finally plotted------
phi=linspace(0,180,5000);
yax(1)=array_factor(gbest,(pi/180)*phi(1));
maxi=yax(1);
for i=2:5000%This loop finds out the maximum gain 
    yax(i)=array_factor(gbest,(pi/180)*phi(i));
    if maxi<yax(i)
        maxi=yax(i);
    end;
end;
for i=1:5000%This loop normalizes the Y-axis and finds the normalized gain values in decibels 
    yax(i)=yax(i)/maxi;
    yax(i)=10*log10(yax(i));
end;
plot(phi,yax,'k')
xlabel('Azimuth angle(deg)');
ylabel('Gain(db)');































































































































































































