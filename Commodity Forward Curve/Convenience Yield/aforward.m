function S = aforward(fT,sT,x0,alpha,m,sig,g0,a,ita,T,N)
% -------------------------------------------------------------------------
% S = aforward(fT,sT,x0,alpha,m,sig,g0,a,ita,T,N)
% This function simulates the term strcture of forward rates.
%
% S = output matrix of average simulated forward rates.
% fT = vector of forward rates to each maturity.
% sT = vector of seasonality factor to each maturity.
% x0 = initial average forward rate.
% alpha = mean reversion rate of average forward rate.
% m = long term mean of average forward rate.
% sig = volatility of average forward rate.
% g0 = vector of initial forward rates to different maturities.
% a = vector of long term mean of convenience yield.
% ita = vector of volatility of convenience yield.
% T = vector of maturities.
% N = number of paths.
% -------------------------------------------------------------------------

fT = fT(:);
sT = sT(:);
g0 = g0(:);
a = a(:);
ita = ita(:);
T = T(:);

nfT = length(fT);
nsT = length(sT);
ng0 = length(g0);
na = length(a);
nita = length(ita);
nT = length(T);

% checking inputs
if (nfT~=nsT || nfT~=ng0 || nfT~=na || nfT~=nita || nfT~=nT)
    fprintf('Input dimensions are not correct.\n');
    return;
end

% simulating paths of forward rates
frates = zeros(nT,nT);
for i = 1:N
    frates = frates + forward(fT,sT,x0,alpha,m,sig,g0,a,ita,T);
end

S = frates / N;
