function S = simulatepathperiod(random,S0,gamma,phi,mu,alpha,sig,ti)

% -------------------------------------------------------------------------
% S = simulatepathperiod(random,S0,gamma,phi,mu,alpha,sig,muk,sigk,lambda,ti)
% This program simulates the commodity price path.
%
% S = output of simulated path.
% random = random numbers.
% S0 = initial commodity price.
% gamma = multiplication factor.
% phi = periodic argument.
% mu = long-term mean.
% alpha = speed of mean reversion.
% sig = volatility.
% muk = mean of jump size.
% sigk = volatility of jump size.
% lambda = jump intensity.
% ti = vector of simulated time points.
% -------------------------------------------------------------------------

n = length(ti);
Z = random(:);
path = zeros(n,1);
path(1) = log(S0) + (mu-alpha*log(S0))*ti(1) + ... 
                                 sig*sqrt(ti(1))*Z(1);
for i=2:n
    path(i) = path(i-1) + ... 
        ((mu-alpha*path(i-1)))*(ti(i)-ti(i-1)) + ...
        sig*sqrt(ti(i)-ti(i-1))*Z(i);
end

S = exp(gamma*sin(4*pi*ti(:)+phi)).*exp(path);
%S = exp(path);
