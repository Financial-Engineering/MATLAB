function F = forward(fT,sT,alpha,m,sig,g0,a,ita,T)
% -------------------------------------------------------------------------
% F = forward(fT,sT,x0,alpha,m,sig,g0,a,ita,T)
% This function simulates the term strcture of forward rates.
%
% F = output matrix of simulated forward rates.
% fT = vector of forward rates to each maturity.
% sT = vector of seasonality factor to each maturity.
% alpha = mean reversion rate of average forward rate.
% m = long term mean of average forward rate.
% sig = volatility of average forward rate.
% g0 = vector of initial convenience yield to different maturities.
% a = vector of long term mean of convenience yield.
% ita = vector of volatility of convenience yield.
% T = vector of maturities.
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

% calculating initial forward rate to each maturity
Fbar = mean(fT);
F0T = Fbar*exp(sT-g0.*T);
x0 = log(Fbar);

% random number generation, W1 and W2
rn1 = randn(nT,1);
rn2 = randn(nT,1);

% forward rates and convenience yield at each maturity date
frates = zeros(nT,nT);
yields = zeros(nT,nT);
rates = zeros(nT,1);
% generate forward rate to each maturity date
dt = [T(1);T(2:nT)-T(1:nT-1)];
rates(1,1) = x0 + (m-alpha*x0)*dt(1) + sig*rn1(1)*sqrt(dt(1)); % change to match FP.
yields(:,1) = g0 - a.*g0*dt(1) + ita*rn2(1)*sqrt(dt(1));
frates(:,1) = log(F0T) + ((m-alpha*x0) + g0.*(a.*T+1))*dt(1) + sig*rn1(1)*sqrt(dt(1)) - ita.*T*rn2(1)*sqrt(dt(1)); % change to match FP.
a(2:nT) = a(1:nT-1);
ita(2:nT) = ita(1:nT-1);
frates(:,1) = exp(frates(:,1));
for i=2:nT
    if(i<nT)
        a(i+1:nT) = a(i:nT-1);
        ita(i+1:nT) = ita(i:nT-1);
    end
    rates(i) = rates(i-1) + alpha*(m-rates(i-1))*dt(i) + sig*rn1(i)*sqrt(dt(i));
    yields(i:nT,i) = yields(i:nT,i-1) - a(i:nT).*yields(i:nT,i-1)*dt(i) + ita(i:nT)*rn2(i)*sqrt(dt(i));
    frates(i:nT,i) = log(frates(i:nT,i-1)) + (alpha*(m-rates(i-1,1)) + yields(i:nT,i-1).*(a(i:nT).*(T(i:nT)-T(i))+1))*dt(i) + sig*rn1(i)*sqrt(dt(i)) - ita(i:nT).*(T(i:nT)-T(i))*rn2(i)*sqrt(dt(i));
    frates(i:nT,i) = exp(frates(i:nT,i));
end

F = frates;
