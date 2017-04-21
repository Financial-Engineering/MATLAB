function P = varianceswap(S,Shat,KC,KP,r,sigc,sigp,T)
% -------------------------------------------------------------------------
% P = varianceswap(S,Shat,KC,KP,r,sigc,sigp,T)
% This function calculates the value of variance swap.
%
% P = output value of variance swap.
% S = stock price.
% Shat = stock level.
% KC = vector of call strike prices.
% KP = vector of put strike prices.
% r = risk-free rate.
% sigc = vector of call volatilities.
% sigp = vector of put volatilities.
% T = time to maturity.
% -------------------------------------------------------------------------

wp = w(-1,Shat,KP,T);
wc = w(1,Shat,KC,T);

P = sqrt(2/T*(r*T-S/Shat*exp(r*T)+1-log(Shat/S))+exp(r*T)*pip(wc,wp,S,r,sigc,sigp,KC,KP,T));
