function f = solvingFunc(rhoinf,rho1M,rhoM1M,M)
% --------------------------------------------------------------
% f = slovingFunc(rhoinf,rho1M,rho1M,M)
% f = output function value.
% rhoinf = rho infinity value.
% rho1M = rho 1 to M value.
% rhoM1M = rho M-1 to M value.
% M = size of correlation matrix.
% --------------------------------------------------------------

f = (rho1M-rhoinf)/(1-rhoinf) - ((rhoM1M-rhoinf)/(1-rhoinf))^(M-1);
