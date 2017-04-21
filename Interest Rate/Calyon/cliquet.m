function P = cliquet(cp,S,alpha,r,b,sig,n,t,T)

% -------------------------------------------------------------------------
% P = cliquet(cp,S,alpha,r,b,sig,n,t,T)
%
% This function calculates the prcing of cliquet.

% P = output price.
% cp = 'c' if call; 'p' if put.
% S = current stock price.
% alpha = constant.
% r = vector of risk-free rates.
% b = vector of cost-of-carries.
% sig = vector of volatilities.
% n = number of forward-start contract.
% t = vector of time to forward-start dates.
% T = vector of time to maturities of the forward start options.
% -------------------------------------------------------------------------

call = 0;
put = 0;
for i=1:n
    d1 = (log(1/alpha)+(b(i)+sig(i)^2/2)*(T(i)-t(i)))/(sig(i)*sqrt(T(i)-t(i)));
    d2 = d1 - sig(i)*sqrt(T(i)-t(i));
    
    call = call + S*exp((b(i)-r(i))*t(i))*(exp((b(i)-r(i))*(T(i)-t(i)))*cnorm(d1)-alpha*exp(-r(i)*(T(i)-t(i)))*cnorm(d2));
    put = put + S*exp((b(i)-r(i))*t(i))*(alpha*exp(-r(i)*(T(i)-t(i)))*cnorm(-d2)-exp((b(i)-r(i))*(T(i)-t(i)))*cnorm(d1));
end

if (cp=='c')
    P = call;
else
    P = put;
end
