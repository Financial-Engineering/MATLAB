function P = LevyIntegrate(CP,S,K,r,b,sig,n,Sa,t0,tn,t,T)
% -------------------------------------------------------------------------
% P = Reciprocal(CP,S,K,r,b,sig,n,Sa,t0,tn,t,T)
% This function calculates reciprocal Asian option price.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% S =   the current asset price.
% K =   the strike price.
% r =   the risk-free rate.
% b =   the cost of carry.
% sig = the volaitlity.
% n =   total number of fixings minus one.
% Sa =  the arithmetic average of the known asset price fixings.
% t0 =  time to the first fixing from contract origination date.
% tn =  time to the last fixing.
% t =   the current time measured from contract initiation date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

if (CP ~= 'c' && CP ~= 'p')
    fprintf('Call/Put CP must be ''c'' or ''p''\n');
    return;
end

if(t>t0)
    Sa = Sa;
elseif (t==t0)
    Sa = S;
else
    Sa = 0;
end

tau = T - t; % tau is the remaining time to maturity.
h = (tn-t0)/n;
m = floor((t-t0)/h);

[EM1 EM2] = LevyMomentMatching(S,b,sig,n,t0,tn,t);

mu = 2*log(EM1) - 1/2*log(EM2);
vol = sqrt(log(EM2)-2*log(EM1));
c = (m+1)/(n+1)*Sa;

if CP == 'c'
    al = K - c;
    bu = 1000;  
    
    price = exp(-r*tau)*integrate('LevyIntegral',1000,al,bu,CP,K,c,mu,vol);
    fprintf('The price of the Asian call option = %.4f\n', price);
  

else
    al = 0;
    bu = K - c;
    price = exp(-r*tau)*integrate('LevyIntegral',1000,al,bu,CP,K,c,mu,vol);
    fprintf('The price of the Asian put option = %.4f\n', price);
end
