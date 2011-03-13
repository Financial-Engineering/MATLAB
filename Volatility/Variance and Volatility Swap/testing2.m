% This program tests the volatility swap function.

ita = 5.81175;
a = 0.127455;
b = 0.7896510;
I = 0;
V = 0.00015763;
v0 = 0.0361;
dt = 1/252;
T = 0.5;

volatilityswap(a,b,V,v0,I,ita,T,dt)
