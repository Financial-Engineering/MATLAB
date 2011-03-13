function P = caplet(S,K,df,mu,sig,T)

% -------------------------------------------------------------------------
% P = floorlet(S,K,df,sig,T)
%
% This function calculates the price for floorlet.
%
% P = output price.
% S = current stock price.
% K = strike price.
% df = discount factor.
% mu = drift rate.
% sig = volatility.
% T = time-to-maturity.
% -------------------------------------------------------------------------

d1 = (log(S/K)+(mu+sig^2/2)*T)/(sig*sqrt(T));
d2 = d1 - sig*sqrt(T);

P = df*(S*cnorm(d1)-K*cnorm(d2));
