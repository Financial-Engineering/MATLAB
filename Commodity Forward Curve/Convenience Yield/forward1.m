function F = forward1(fT,sT,alpha,m,sig,a,ita,T,t)
% -------------------------------------------------------------------------
% F = forward1(fT,sT,x0,alpha,m,sig,a,ita,T,t)
% This function simulates the term strcture of forward rates.
%
% F = output matrix of simulated forward rates.
% fT = vector of forward rates to each maturity.
% sT = vector of seasonality factor to each maturity.
% alpha = mean reversion rate of average forward rate.
% m = long term mean of average forward rate.
% sig = volatility of average forward rate.
% a = vector of long term mean of convenience yield.
% ita = vector of volatility of convenience yield.
% T = vector of maturities.
% t = destination point.
% -------------------------------------------------------------------------

fT = fT(:);
sT = sT(:);
a = a(:);
ita = ita(:);
T = T(:);

nfT = length(fT);
nsT = length(sT);
na = length(a);
nita = length(ita);
nT = length(T);

% checking inputs.
if (nfT~=na || nfT~=nita || nfT~=nT)
    fprintf('Input dimensions are not correct.\n');
    return;
end
% calculating initial forward rate to each maturity.
Fbar = mean(fT);
x0 = log(Fbar);
g0 = -(log(fT/Fbar)-sT)./T;

% random number generation, W1 and W2.
randn('seed',1);
rn1 = randn(t/T(1),1);
randn('seed',2);
rn2 = randn(t/T(1),1);

% forward rates and convenience yield at each maturity date.
frates = zeros(nT,t/T(1));
yields = zeros(nT,t/T(1));
rates = zeros(t/T(1),1);
% generate forward rate to each maturity date.
dt = T(1);
rates(1) = x0 + alpha*(m-x0)*dt + sig*rn1(1)*sqrt(dt); % change to match FP.
yields(:,1) = g0 - a.*g0*dt + ita*rn2(1)*sqrt(dt);
sT = rotating(sT);
frates(:,1) = exp(rates(1))*exp(sT-yields(:,1).*T);
for i=2:t/T(1)
    rates(i) = rates(i-1) + alpha*(m-rates(i-1))*dt + sig*rn1(i)*sqrt(dt);
    yields(:,i) = yields(:,i-1) - a.*yields(:,i-1)*dt + ita*rn2(i)*sqrt(dt);
    sT = rotating(sT);
    frates(:,i) = exp(rates(i))*exp(sT-yields(:,i).*T);
end

F = frates;
