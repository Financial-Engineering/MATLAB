function P = capletPriceBlack(f,K,sig,df,T)
% -------------------------------------------------------------------------
% P = capletPriceBlack(f,K,sig,df,T)
% This function calculates the caplet price using Black's model.
%
% P = output price.
% f = forward rate.
% K = strike price.
% sig = forward rate volaitility.
% df = discount factor.
% T = time to maturity.
% -------------------------------------------------------------------------

d1 = (log(f/K)+1/2*sig^2*T)/(sig*sqrt(T));
d2 = d1 - sig*sqrt(T);

P = df*(f*cnorm(d1)-K*cnorm(d2));
