function F = forwardcorrelated(fT,sT,alpha,m,sig,a,ita,S1,alpha1,m1,sig1,rho,T,t)
% -------------------------------------------------------------------------
% F = forwardcorrelated(fT,sT,x0,alpha,m,sig,a,ita,S1,alpha1,m1,sig1,rho,T,t)
% This function simulates the correlated term strcture of forward rates
% with another asset class.
%
% F = output matrix of simulated forward rates, average forward rates and assetclass rates.
% fT = vector of forward rates to each maturity.
% sT = vector of seasonality factor to each maturity.
% alpha = mean reversion rate of average forward rate.
% m = long term mean of average forward rate.
% sig = volatility of average forward rate.
% a = vector of long term mean of convenience yield.
% ita = vector of volatility of convenience yield.
% S1 = initial asset class rate.
% alpha1 = mean reversion rate of asset class.
% m1 = long term mean of asset class.
% sig1 = volatility of asset calss.
% rho = correlation between forward rates and asset class.
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

% random number generation, W1, W2 and W3 with d<W1,W3>=rho.
randn('seed',1);
rn = randn2(t/T(1),[0;0],[1;1],rho);
rn1 = rn(1,:);
randn('seed',2);
rn2 = randn(t/T(1),1);
rn3 = rn(2,:);

% forward rates and convenience yield at each maturity date.
frates = zeros(nT,t/T(1));
yields = zeros(nT,t/T(1));
rates = zeros(t/T(1),1);
assetclass = zeros(t/T(1),1);
% generate forward rate to each maturity date.
dt = T(1);
rates(1) = x0 + alpha*(m-x0)*dt + sig*rn1(1)*sqrt(dt); % change to match FP.
assetclass(1) = S1 + alpha1*(m1-S1)*dt + sig1*rn3(1)*sqrt(dt);
yields(:,1) = g0 - a.*g0*dt + ita*rn2(1)*sqrt(dt);
sT = rotating(sT);
frates(:,1) = exp(rates(1))*exp(sT-yields(:,1).*T);
for i=2:t/T(1)
    rates(i) = rates(i-1) + alpha*(m-rates(i-1))*dt + sig*rn1(i)*sqrt(dt);
    assetclass(i) = assetclass(i-1) + alpha1*(m1-assetclass(i-1))*dt + sig1*rn3(i)*sqrt(dt);
    yields(:,i) = yields(:,i-1) - a.*yields(:,i-1)*dt + ita*rn2(i)*sqrt(dt);
    sT = rotating(sT);
    frates(:,i) = exp(rates(i))*exp(sT-yields(:,i).*T);
end

F = [frates;exp(rates');assetclass'];
