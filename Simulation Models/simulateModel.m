% Generated simulated values for the Ornstein Uhlenbeck process with
% time-dependent or time-independent drift and volatility
function [S] = simulateModel(S0, model_parms, T, simulate, init_seed)
    if ((length(model_parms.drift)==1) && (length(model_parms.volatility)==1)) % no time-dependent parameters
        parms.drift = model_parms.drift;
        parms.speed = model_parms.speed;
        parms.volatility = model_parms.volatility;
        parms.deltaT = model_parms.deltaT;
        time_dependent = 0;
    else
        if (isfield(model_parms, 'speed'))
            parms.speed = model_parms.speed;
        end
        parms.deltaT = model_parms.deltaT;
        time_dependent = 1;
    end
    
    if (exist('init_seed', 'var'))
        obj=Random(init_seed);
    end
    
    n = T*252-1;
    S = [S0 zeros(1, n)];
    for t=1:n
        if (exist('init_seed', 'var'))
            wt = obj.nextn;        
        else
            %wt = randn;
            wt = razor_normals(t);
        end       
        if (time_dependent)
            parms.drift = model_parms.drift(t);
            parms.volatility = model_parms.volatility(t);
        end
        S(t+1) = simulate(S(t), wt, parms);
    end
end