 function fitness=fungsiobjektif2(x)
   X0(1)=x(1);
   X0(2)=x(2);
   X0(3)=x(3);
   X0(4)=x(4);
% x = [-80.18 -28.85 32.98 1.87];

    Te  = X0(1) + 273.15;
    Tmc = X0(2) + 273.15;
    Tc  = X0(3) + 273.15; 
    dT  = X0(4);
    Tme = Tmc-dT;
    X   = 0.37;
    
    Ql  = 500;
    Tdr = 5;
    Tcl = Te+Tdr;
    
    H   = 7000;
    Cel = 0.12;
    Opp = 10;
    Int = 0.08;
    
    CRF = (Int*((1+Int)^Opp))/(((1+Int)^Opp)-1);
    Uoe = 18.03;
    Uoc = 6.85;
    Uocas = 64.87;
    
    t1 = Te;
    p1 = 0.1; %refpropm('P','T',t1,'Q',1,'CO2','ETHYLENE', [X (1-X)]);
    h1 = 0.02; %refpropm('H','T',t1,'Q',1,'CO2','ETHYLENE', [X (1-X)]);
    s1 = 0.03; %refpropm('S','P',p1,'H',h1,'CO2','ETHYLENE', [X (1-X)]);
    
    p2 = 0.1; % refpropm('P','T',Tmc,'Q',0,'CO2','ETHYLENE', [X (1-X)]);
    RpL = p2/p1;
    eff_is = 1-0.04*RpL;
    h2s = 0.22; %refpropm('H','P',p2,'S',s1,'CO2','ETHYLENE', [X (1-X)]);
    h2 = ((h2s-1)/eff_is)+h1;
    
    p3 = p2;
    t3 = Tmc;
    h3 = 0.33; %refpropm('H','P',p3,'Q',0,'CO2','ETHYLENE', [X (1-X)]);
    
    p4 = p1;
    h4 = h3;
    t4 = Te;
    
    
t5 = Tmc;
p5 = 0.8; %refpropm('P','T',t5,'Q',1,'PROPANE');
h5 = 0.2; %refpropm('H','T',t5,'Q',1,'PROPANE');
s5 = 0.7; %refpropm('S','P',p5,'H',h5,'PROPANE');

p6 = 0.1; %refpropm('P','T',Tc,'Q',1,'PROPANE');
RpH = p6/p5;
eff_is =  1-0.04*RpH;
h6s = 0.9; %refpropm('H','P', p6,'S',s5,'PROPANE');
h6 = ((h6s-h5)/eff_is)+h5;

t7 = Tc;
p7 = p6;
h7 = 0.11; %refpropm('H','P',p7,'Q',0,'PROPANE');
 

t8 = 29;
p8 = p5;
h8 = h7;

%refrigerant mass flow 
mL = Ql/(h1-h4);
mH = mL* (h2-h3)/(h5-h8);

%dead state
T0 = 25+273.15;
p0 = 101.3;

%work
eff_m = 0.93;
Wfane = 50/eff_m;
Wfanc = 60/eff_m;
Wltc = mL* (h2-h1)/eff_m;
Whtc = mH* (h6-h5)/eff_m;
Qm = mL* (h2-h3);
Qh = mH* (h6-h7);

%Heat transfer area
Aoc = Qh/ (Uoc*abs(Tc-T0));
Aoe = Ql/ (Uoe*abs(Te-Tcl));
Aocas = Qm/ (Uocas*dT);

%total exergy input
Exin = Whtc + Wltc + Wfane + Wfanc;

%exergy output
Exout = Ql*((T0/Tcl)-1);

%total exergy destruction
ExDtot = Exin - Exout;
exergy_eff = 1-(ExDtot/Exin);


%Termoekonomi

Chtc = 9624.2*(0.001*Whtc ^0.46);
Cltc = 10167.5*((0.001*Wltc)^0.46);
Ccon = 1397*(Aoc^0.89) + 629.05*((0.001*Wfanc)^0.76);

Cevap = 1396*(Aoe^0.89) + 629.05*((0.001*Wfane)^0.76);

Ccas = 2382.9*(Aocas^0.68);

Ctot = (Chtc + Cltc + Ccon + Cevap + Ccas)*CRF + Cel*H*0.001* (Wltc + Whtc + Wfane + Wfanc);


% f(1) = -exergy_eff*100; 
fitness = Ctot;
end

 

