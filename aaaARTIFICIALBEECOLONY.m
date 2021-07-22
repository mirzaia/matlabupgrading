%ARTIFICIAL BEE COLONY
    load ('prop.mat')
    %/* Control Parameters of ABC algorithm*/
    NP=Dimension; %/* The number of colony size (employed bees+onlooker bees)*/
    FoodNumber=1; %/*The number of food sources equals the half of the colony size*/
    limit=100; %/*A food source which could not be improved through "limit" trials is abandoned by its employed bee*/
    maxCycle=2; %/*The number of cycles for foraging {a stopping criteria}*/
    
    %/* Problem specific variables*/
    objfun='coba1'; %cost function to be optimized
    
    runtime=20;%/*Algorithm can be run many times in order to see its robustness*/
       
    GlobalMins=zeros(1,runtime);
    
    for r=1:runtime
        
        r
        Range = repmat((UB-LB),[FoodNumber 1]);
        Lower = repmat(LB, [FoodNumber 1]);
        Foods = rand(FoodNumber,Dimension) .* Range + Lower;
        
        ObjVal=feval(objfun,Foods);
        Fitness=calculateFitness(ObjVal);
        
        %reset trial counters
        trial=zeros(1,FoodNumber);
        
        %/*The best food source is memorized*/
        BestInd=find(ObjVal==min(ObjVal));
        BestInd=BestInd(end);
        GlobalMin=ObjVal(BestInd);
        GlobalParams=Foods(BestInd,:);
        
        iter=1;
        while ((iter <= maxCycle)),
            
            %%%%%%%%% EMPLOYED BEE PHASE %%%%%%%%%%%%%%%%%%%%%%%%
                i=1
                
                %/*The parameter to be changed is determined randomly*/
                Param2Change=fix(rand*Dimension)+1;
                
                %/*A randomly chosen solution is used in producing a mutant solution of the solution i*/
                neighbour=fix(rand*(FoodNumber))+1;
                
                %/*Randomly selected solution must be different from the solution i*/
               
                sol=Foods(i,:);
                %  /*v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij}) */
                sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
                
                %  /*if generated parameter value is out of boundaries, it is shifted onto the boundaries*/
                ind=find(sol<LB);
                sol(ind)=LB(ind);
                ind=find(sol>UB);
                sol(ind)=UB(ind);
                
                %evaluate new solution
                ObjValSol=feval(objfun,sol);
                FitnessSol=calculateFitness(ObjValSol);
                
                % /*a greedy selection is applied between the current solution i and its mutant*/
                if (FitnessSol>Fitness(i)) %/*If the mutant solution is better than the current solution i, replace the solution with the mutant and reset the trial counter of solution i*/
                    Foods(i,:)=sol;
                    Fitness(i)=FitnessSol;
                    ObjVal(i)=ObjValSol;
                    trial(i)=0;
                else
                    trial(i)=trial(i)+1; %/*if the solution i can not be improved, increase its trial counter*/
                end;
                
                
            
            
            %%%%%%%%%%%%%%%%%%%%%%%% CalculateProbabilities %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %/* A food source is chosen with the probability which is proportioal to its quality*/
            %/*Different schemes can be used to calculate the probability values*/
            %/*For example prob(i)=fitness(i)/sum(fitness)*/
            %/*or in a way used in the method below prob(i)=a*fitness(i)/max(fitness)+b*/
            %/*probability values are calculated by using fitness values and normalized by dividing maximum fitness value*/
            
            prob=(0.9.*Fitness./max(Fitness))+0.1;
            
            %%%%%%%%%%%%%%%%%%%%%%%% ONLOOKER BEE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            i=1;
            t=0;
            while(t<FoodNumber)
                if(rand<prob(i))
                    t=t+1;
                    %/*The parameter to be changed is determined randomly*/
                    Param2Change=fix(rand*Dimension)+1;
                    
                    %/*A randomly chosen solution is used in producing a mutant solution of the solution i*/
                    neighbour=fix(rand*(FoodNumber))+1;
                    
                    %/*Randomly selected solution must be different from the solution i*/
%                     while(neighbour==i)
%                         neighbour=fix(rand*(FoodNumber))+1;
                   
                    
                    sol=Foods(i,:);
                    %  /*v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij}) */
                    sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
                    
                    %  /*if generated parameter value is out of boundaries, it is shifted onto the boundaries*/
                    ind=find(sol<LB);
                    sol(ind)=LB(ind);
                    ind=find(sol>UB);
                    sol(ind)=UB(ind);
                    
                    %evaluate new solution
                    ObjValSol=feval(objfun,sol);
                    FitnessSol=calculateFitness(ObjValSol);
                    
                    % /*a greedy selection is applied between the current solution i and its mutant*/
                    if (FitnessSol>Fitness(i)) %/*If the mutant solution is better than the current solution i, replace the solution with the mutant and reset the trial counter of solution i*/
                        Foods(i,:)=sol;
                        Fitness(i)=FitnessSol;
                        ObjVal(i)=ObjValSol;
                        trial(i)=0;
                    else
                        trial(i)=trial(i)+1; %/*if the solution i can not be improved, increase its trial counter*/
                    end;
                end;
                
                i=i+1;
                if (i==(FoodNumber)+1)
                    i=1;
                end;
            end;
            
            
            %/*The best food source is memorized*/
            ind=find(ObjVal==min(ObjVal));
            ind=ind(end);
            if (ObjVal(ind)<GlobalMin)
                GlobalMin=ObjVal(ind);
                GlobalParams=Foods(ind,:);
            end;
            
            
            %%%%%%%%%%%% SCOUT BEE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %/*determine the food sources whose trial counter exceeds the "limit" value.
            %In Basic ABC, only one scout is allowed to occur in each cycle*/
            
            ind=find(trial==max(trial));
            ind=ind(end);
            if (trial(ind)>limit)
                trial(ind)=0;
                sol=(UB-LB).*rand(1,Dimension)+LB;
                ObjValSol=feval(objfun,sol);
                FitnessSol=calculateFitness(ObjValSol);
                Foods(ind,:)=sol;
                Fitness(ind)=FitnessSol;
                ObjVal(ind)=ObjValSol;
            end;
            
            
            
            fprintf('Ýter=%d ObjVal=%g\n',iter,GlobalMin);
            iter=iter+1;
            
        end % End of ABC
        
        GlobalMins(r)=GlobalMin;
     end;%end of runs
    save ('ABC.mat')
    