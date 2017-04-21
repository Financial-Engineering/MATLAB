function L = local(S0,r,S,t)
% -------------------------------------------------------------------------
% L = local(S,r,t)
% This function calculates the local volatility from Black-Scholes implied
% volatility surface.
%
% L = output local volatility.
% S0 = current stock price.
% r = risk-free rate.
% S = stock level.
% t = time point.
% -------------------------------------------------------------------------

h = 1;
F = S0*exp(r*t);
y = log(S/F);
wupt = imp(y,t+h*t);
wdownt = imp(y,t-h*t);
upt = t+h*t;
downt = t-h*t;
fdt = (wupt - wdownt) / (upt - downt);

wupy = imp(y+h*y,t);
wdowny = imp(y-h*y,t);
upy = y+h*y;
downy = y-h*y;
fdy = (wupy - wdowny) / (2*(upy-downy));

w = imp(y,t);
sdy = (wupy - 2*w + wdowny) / (upy-downy)^2;

L = fdt / (1 - y/w*fdy + 1/4*(-1/4-1/w+y^2/w^2)*fdy^2 + 1/2*sdy);
