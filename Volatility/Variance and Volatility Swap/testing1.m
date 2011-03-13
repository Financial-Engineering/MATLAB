% This program tests the variance and volatility swap functions.

% variance swap
S = 100;
Shat = 100;
T = 0.25;
r = 0.05;
KP = linspace(45,100,12);
KC = linspace(100,140,9);
sigp = linspace(0.31,0.20,12);
sigc = linspace(0.20,0.12,9);
varianceswap(S,Shat,KC,KP,r,sigc,sigp,T)
