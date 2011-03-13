function v = volatilityswap(a,b,V,v0,I,ita,T,dt)

% -------------------------------------------------------------------------
% v = volatilityswap(a,b,V,v0,I,ita,T,dt)
% This function calculates the value of volatility swap.
%
% v = output value of volatility swap.
% a = alpha value.
% b = beta value.
% V = long term variance.
% v0 = initial variance.
% I = expected variance up to the valuation date.
% ita = Pearson kurtosis.
% T = time to maturity.
% dt = time interval of volatility observations.
% -------------------------------------------------------------------------

    q = V/dt;
    k = (1-a-b)/dt;
    g = a*sqrt((ita-1)/dt);

    ft = q^2*T^2-4*q^2*(g^2-k)/(k*(g^2-2*k))*(T+(exp(-k*T)-1)/k)-...
                               4*q^2*k^2/((g^2-k)^2*(g^2-2*k))*((1-exp(g^2-2*k)*T)/(g^2-2*k)+(1-exp(-k*T))/k)-...
                               2*q^2*(g^2+k)/(g^2-k)*(exp(-k*T)*T/k+1/k^2*(exp(-k*T)-1));

    gt = 2*q/k*T-4*q*(g^2-k)/(k^2*(g^2-2*k))*(1-exp(-k*T))+...
                                4*q*k/((g^2-k)^2*(g^2-2*k))*(exp((g^2-2*k)*T)-exp(-k*T))+...
                                2*q*(g^2+k)/(k*(g^2-k))*T*exp(-k*T);

    ht = 2/(k*(g^2-2*k))*(exp((g^2-2*k)*T)-1)-2/(k*(g^2-k))*(exp((g^2-2*k)*T)-exp(-k*T));

    lt = 2*q*(T+(exp(-k*T)-1)/k);

    nt = 2/k*(1-exp(-k*T));

    F = q*(T+(exp(-k*T)-1)/k)+1/k*(1-exp(-k*T))*v0+I;

    G = ft+gt*v0+ht*v0^2+lt*I+nt*v0*I+I^2;

    varI = G-F^2;

    v = sqrt(F)-varI/(8*F^(3/2));
end
