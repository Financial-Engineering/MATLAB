function VBS = imp(y,t)
% -------------------------------------------------------------------------
% VBS = imp(y,t)
% This function gives the Black-Scholes implied volatility with
% dimensionless stock level y and time to maturity t.
%
% VBS = output Black-Scholes implied volatility.
% y = ln(K/F);
% t = time to maturity.
% -------------------------------------------------------------------------

VBS = 0.05*t;
