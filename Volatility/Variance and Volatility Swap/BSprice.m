function BSP = BSprice(ita,S,K,r,sig,T)
% -----------------------------------------------------
% BSprice(ita,S,K,r,sig,T)
% This function calculates the option price
% using the Black-Scholes model.
%
% ita = 1 if call, -1 if put.
% S = stock price.
% K = vector of strike prices.
% r = risk-free rate.
% sig = vector of volatilities.
% T = time to maturity.
% -----------------------------------------------------

K = K(:);
sig = sig(:);
if (ita~=1 && ita~=-1)
    fprintf('ita must be 1 or -1.\n');
    return;
end
d1 = (log(S./K)+(r+1/2*sig.^2)*T)./(sig*sqrt(T));
d2 = d1 - sig*sqrt(T);

BSP = ita*(S.*cnorm(ita*d1)-(K*exp(-r*T)).*cnorm(ita*d2));
