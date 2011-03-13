function S = simulatepathjd(random,S0,mu,alpha,sig,muk,sigk,lambda,ti)

% -------------------------------------------------------------------------
% S = simulatepathjd(random,S0,mu,alpha,sig,muk,sigk,lambda,ti)
% This program simulates the commodity price path.
%
% S = output of simulated path.
% random = random numbers.
% mu = long-term mean.
% alpha = speed of mean reversion.
% sig = volatility.
% muk = mean of jump size.
% sigk = volatility of jump size.
% lambda = jump intensity.
% ti = vector of simulated time points.
% -------------------------------------------------------------------------

n = length(ti);
Z = random;
N = zeros(n,1);
M = zeros(n,1);
path = zeros(n,1);
N(1) = poissrnd(lambda*ti(1));
for j=1:N(1)
    M(1) = M(1) + randn*sigk + log(1+muk)-1/2*sigk^2;
end
for i=2:n
    N(i) = poissrnd(lambda*(ti(i)-ti(i-1)));
    for j=1:N(i)
        M(i) = M(i) + randn*sigk + log(1+muk)-1/2*sigk^2;
    end
end
path(1) = log(S0) + (mu-alpha*log(S0))*ti(1) + ... 
                                 sig*sqrt(ti(1))*Z(1) + M(1);
for i=2:n
    path(i) = path(i-1) + ... 
        (mu-alpha*path(i-1))*(ti(i)-ti(i-1)) + ...
        sig*sqrt(ti(i)-ti(i-1))*Z(i) + M(i);
end

S = exp(path);
