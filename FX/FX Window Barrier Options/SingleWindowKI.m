function P = SingleWindowKI(cp,ud,S,K,H,r,c,sig,T)

% -------------------------------------------------------------------------
% P = SingleBarrierKnockIn(S,K,H,r,c,sig,T)
% This function calculates the price of single barrier knock in options.
%
% P = the price of single barrier knock in options.
% cp = 1 for a call, -1 for a put.
% ud = 1 for an up barrier, -1 for a down barrier.
% S = current stock price.
% K = strike price.
% H = the barrier.
% r = 3 by 1 vector of risk-free rates.
% c = 3 by 1 vector of convenience yields.
% sig = 3 by 1 vector of volatilities.
% T = 3 by 1 vector of times.
% -------------------------------------------------------------------------

d1 = (log(S/K)+(c(3)-r(3)+sig(3)^2/2)*T(4))/(sig(3)*sqrt(T(4)));
d2 = d1 - sig(3)*sqrt(T(4));

callprice = S * exp(-c(3)*T(4))*cnorm(d1) - K*exp(-r(3)*T(4))*cnorm(d2);
putprice =  K * exp(-r(3)*T(4))*cnorm(-d2) - S*exp(-c(3)*T(4))*cnorm(-d1);

if (cp==1)
    P = callprice - SingleWindowKO(cp,ud,S,K,H,r,c,sig,T);
else
    P = putprice - SingleWindowKO(cp,ud,S,K,H,r,c,sig,T);
end
