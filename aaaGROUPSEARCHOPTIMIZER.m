%GROUP SEARCH OPTIMIZER
    close all
    xiter = [];
    fxiter = [];
 
    testct = 1;
    for tc = 1:testct
        tc
        
        xmin = [];
        fxmin = [];
load ('prop.mat')  
        niter = 500;
        
        options = gsoptions();
        options.a           = round(sqrt(Dimension+1));
        options.tmax        = pi/(options.a)^2;
        options.amax        = options.tmax/2;
        options.limitspace  = 'dont_move';
        options.niterations = niter;
        options.nscroungers = 0.8;
        options.nproducers  = 1;
        options.error       = 0;
        options.popsize     = 48;
        options.elitesize   = 10;
        options.stall       = 10;
        options.verbose     = 0;
        options.lmax        = 1095.445115010332;
               
        tic;
        CostFunction=@(x) (1/coba1(x))
        [x fx]=gso(CostFunction,UB,LB,options);
        
        fprintf('Function coba1: \t Solution: %e \t Time: %f\Dimension', min(fx),toc);
        [fxmin, nmin] = min(fx);
        xmin = x(nmin, :);
        
        xiter = [xiter; xmin];
        fxiter = [fxiter; fxmin];
        
    end
   save('GSO.mat')