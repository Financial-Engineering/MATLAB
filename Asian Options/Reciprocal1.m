function P = Reciprocal1(CP,S,K,r,b,sig,n,m,Sa,t0,tn,t,T)
% -------------------------------------------------------------------------
% P = Reciprocal1(CP,S,K,r,b,sig,n,m,Sa,t0,tn,t,T)
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
ti = linspace(t0,tn,n);

sum = 0;
for i=m+1:n
    F(i) = S*exp(b*(ti(i)-t));
    sum = sum + F(i);
end
EM1 = 1/(n-m)*sum;

sum = 0;
for i=m+1:n
    for j=m+1:n
        sum = sum + F(i)*F(j)*exp(sig^2*min(ti(i)-t,ti(j)-t));
    end
end

EM2 = 1/(n-m)^2*sum;

mu = 2*log(EM1) - 1/2*log(EM2);
vol = sqrt(log(EM2)-2*log(EM1));
c = m/n*Sa;
a= (n-m)/n;

if CP == 'c'
    al = 0;
    bu = (K - c) / a;
    
    if bu > 0
        bu = bu;
    else
        bu = 0;
    end

    if(bu == 0)
        price = 0;
        fprintf('The price of the reciprocal Asian call option = %.4f\n', price);
    else
        
        price = exp(-r*tau)*integrate('ReciprocalIntegral1',1000,al,bu,CP,K,c,mu,vol);
        fprintf('The price of the reciprocal Asian call option = %.4f\n', price);
    end

else
    al = max(0,K-c);
    bu = 5000000;
    price = exp(-r*tau)*integrate('ReciprocalIntegral1',5000,al,bu,CP,K,c,mu,vol);
    fprintf('The price of the reciprocal Asian put option = %.4f\n', price);
end
