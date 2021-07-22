%IMPERIAL COMPETITIVE ALGORITHM

%% Problem Definition
load ('prop.mat')
CostFunction=@(x) (1/coba1(x));        % Cost Function

nVar=Dimension;             % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

VarMin= LB;         % Lower Bound of Variables
VarMax= UB;         % Upper Bound of Variables


%% ICA Parameters

MaxIt=100;         % Maximum Number of Iterations

nPop=50;            % Population Size
nEmp=10;            % Number of Empires/Imperialists

alpha=1;            % Selection Pressure

beta=1.5;           % Assimilation Coefficient

pRevolution=0.05;   % Revolution Probability
mu=0.1;             % Revolution Rate

zeta=0.2;           % Colonies Mean Cost Coefficient


%% Globalization of Parameters and Settings

global ProblemSettings;
ProblemSettings.CostFunction=CostFunction;
ProblemSettings.nVar=nVar;
ProblemSettings.VarSize=VarSize;
ProblemSettings.VarMin=VarMin;
ProblemSettings.VarMax=VarMax;

global ICASettings;
ICASettings.MaxIt=MaxIt;
ICASettings.nPop=nPop;
ICASettings.nEmp=nEmp;
ICASettings.alpha=alpha;
ICASettings.beta=beta;
ICASettings.pRevolution=pRevolution;
ICASettings.mu=mu;
ICASettings.zeta=zeta;


%% Initialization

% Initialize Empires
emp=CreateInitialEmpires();

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);


%% ICA Main Loop

for it=1:MaxIt
    
    % Assimilation
    emp=AssimilateColonies(emp);
    
    % Revolution
    emp=DoRevolution(emp);
    
    % Intra-Empire Competition
    emp=IntraEmpireCompetition(emp);
    
    % Update Total Cost of Empires
    emp=UpdateTotalCost(emp);
    
    % Inter-Empire Competition
    emp=InterEmpireCompetition(emp);
    
    % Update Best Solution Ever Found
    imp=[emp.Imp];
    [~, BestImpIndex]=min([imp.Cost]);
    BestSol=imp(BestImpIndex);
    
    % Update Best Cost
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end


%% Results

figure;
%plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
save('ICA.mat')
