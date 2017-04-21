function [S] = simulateOU(S0,  drift, speed, volatility, T)
    parms.drift = drift;
    parms.speed = speed;
    parms.variance = volatility^2;
    n = T*252-1;
    S = [S0 zeros(1, n)];    
    for t=1:n
        wt = randn;
        S(t+1) = simulateNormalMeanReverting(S(t), wt, parms);
    end
end