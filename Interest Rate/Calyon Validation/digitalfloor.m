function P = digitalfloor(S,K,df,sig,T)

% -------------------------------------------------------------------------
% P = digitalfloor(S,K,df,sig,T)
%
% This function calculates the price for cash-or-nothing digital floor
% options.
%
% P = output price.
% S = current stock price.
% K = strike price.
% df = discount factor.
% sig = volatility.
% T = time-to-maturity.
% -------------------------------------------------------------------------

d = (log(S/K)-sig^2/2*T)/(sig*sqrt(T));

P = df*cnorm(-d);
