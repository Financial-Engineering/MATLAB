% This program tests the calibration of commodity simulation.
load rate2historical.txt;
S0 = 25;
gamma = 1;
phi = 0;
muk = 0.5;
sigk = 0.5;
lambda = 5;
ti = linspace(1/365,1,365);
ti = ti(:);
simdata = exp(sin(4*pi*ti)).*exp(flipud(-rate2historical(1:365)));
P = seasonP(simdata,1/365)
simdata = simulatepathperiod(S0,gamma,phi,P(1),P(2),P(3),ti);
P = seasonP(simdata,1/365)
simdata = simulatepathjd(S0,P(1),P(2),P(3),muk,sigk,lambda,ti);
plot(ti,simdata);
P = jumpP(simdata,3)
