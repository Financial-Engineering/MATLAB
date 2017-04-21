% This program tests the SABR volatility surface.

clear;
f = 90;
K = 90;
alpha = 0.12;
beta = 1;
sig = 0.3;
rho = -0.5;
T = 1;
sabrvol(K,f,alpha,beta,sig,rho,T);
