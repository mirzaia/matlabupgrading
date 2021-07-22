%RAINWATER ALGORITHM
clear all; close all; clc;
load ('prop.mat')
N = 20;
alfa=360; 
G=10;
t = 1;

iter = 10;

Rpower=1;
min_flag=1;
minmax = 1;
Rnorm=2; 
convergence_curve=zeros(1,iter);

% Initialize population, position:
if size(UB,2)==1
    X=rand(N,Dimension).*(UB-LB)+LB;
end
if size(UB,2)>1
    for i=1:Dimension
    high=UB(i);
    low=LB(i);
    X(:,i)=rand(N,1).*(high-low)+low;
    end
end
Bestpos=zeros(1,Dimension);
Meanpos=zeros(1,Dimension);
FBest=zeros(1,Dimension);
LBest=zeros(1,Dimension);
Eo=zeros(N,Dimension);
V=zeros(N,Dimension);
M = zeros(N);
P = 0;

% Main Program
while P<iter
for iteration = 1:iter
    
% inisialisasi Search Agent dan Objective Function
[N,Dimension]=size(X);
for i=1:N 
    %%Agent that go out of the search space, are reinitialized randomly .
    Tp=X(i,:)>UB; 
    Tm=X(i,:)<LB; 
    X(i,:)=(X(i,:).*(~(Tp+Tm)))+((rand(1,Dimension).*(UB-UB)+LB).*(Tp+Tm));
end

for i=1:N 
    %L is the location of agent number 'i'
    L=X(i,:); 
    %calculation of objective function for agent number 'i'
    fobj=@(X)(coba1(X));
    fitness(i)=1/fobj(X(i,:));
end

if minmax==1
[best best_X]=min(fitness); %minimization.
else
[best best_X]=max(fitness); %maximization.
end  

if iteration==1
   Fbest=best;Lbest=X(best_X,:);
end
if minmax==1
if best<Fbest  %minimization.
   Fbest=best;Lbest=X(best_X,:);
end
else 
if best>Fbest  %maximization
   Fbest=best;Lbest=X(best_X,:);
end
end

Bestpos=[Bestpos Fbest];
Meanpos=[Meanpos mean(fitness)];

% Hujan jatuh = energi potensial = Ep = 1/2 mv^2
% velocity calculation
Fmax=max(fitness); Fmin=min(fitness); Fmean=mean(fitness); 
[i N]=size(fitness);

if Fmax==Fmin
   vo=ones(N,1);
else
    
if minmax==1 %for minimization
   best=Fmin;worst=Fmax; 
else %for maximization
   best=Fmax;worst=Fmin; 
end
  
vo=(fitness-worst)./(best-worst); 

end
M = rand(N);
vo=(vo./sum(vo))*M.*t;
% velocity calculation berfungsi untuk menentukan butiran hujan yang jatuh
% terlebih dahulu berdasarkan fitness dari setiap agents.

% [N,Dimension]=size(X);
 final_per=1.5; %In the last iteration, only 1.5 percent of agents 

kbest=final_per+(1-iteration/iter)*(100-final_per); 
kbest=round(N*kbest/100);

[Ms ds]=sort(vo,'descend');

 for i=1:N
     
     for ii=1:kbest
         j=ds(ii);
         if j~=i
            R=norm(X(i,:)-X(j,:),Rnorm); %Euclidian distanse.
         for k=1:Dimension 
             Eo(i,k)=Eo(i,k)+rand*(vo(j))*((X(j,k)-X(i,k))/(R^Rpower+eps));
            
         end
         end
     end
 end

%%acceleration
E = Eo*exp(-alfa*iteration/iter);
a=E.*G;

%movement.
% [N,Dimension]=size(X);
V=rand(N,Dimension).*V+a; 
X=X+V; 

P = P + 1;
convergence_curve(P) = Fbest;
jx=plot((1:iter),convergence_curve,'LineWidth',2); grid on;
title(['Rainfall Algorithm Best Value : ' num2str(Fbest)]);
xlabel('Iteration');
ylabel('Function Value');
end
end
save ('RW.mat')
