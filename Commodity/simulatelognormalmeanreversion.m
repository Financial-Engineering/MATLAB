function S = simulatelognormalmeanreversion(random,S0,mu,alpha,sig,ti)

% -------------------------------------------------------------------------
% S = simulatelognormalmeanreversion(random,S0,mu,alpha,sig,ti)
% This program simulates the commodity price path.
%
% random = random numbers.
% S = output of simulated path.
% mu = long-term mean.
% alpha = speed of mean reversion.
% sig = volatility.
% ti = vector of simulated time points.
% -------------------------------------------------------------------------

n = length(ti);
Z = random;
path = zeros(n,1);
path(1) = log(S0) + (mu-alpha*log(S0))*ti(1) + ... 
                                 sig*sqrt(ti(1))*Z(1);
for i=2:n
    path(i) = log(path(i-1)) + ... 
        (mu-alpha*log(path(i-1)))*(ti(i)-ti(i-1)) + ...
        sig*sqrt(ti(i)-ti(i-1))*Z(i);
end

S = exp(path);
