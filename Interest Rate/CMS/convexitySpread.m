function c = convexitySpread(t0,tf,tau,periods,rate,vol)
    F = buildFlows(tau, periods, rate(1));
    c(:,1) = tf;
    
    for i = 1:length(tf)
        c(i,2) = convexityAdjust(F,t0,tf(i),periods,rate(i),vol(i));
    end
end
