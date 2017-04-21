function P = LevyFixEqual(CP,S,K,r,b,sig,n,Sa,t0,tn,t,T)
% -------------------------------------------------------------------------
% P = LevyFixEqual(S,K,r,b,sig,n,m,Sa,t0,tm,tn,t,T)
% This function calculates the price of a fixed-strike
% Asian option with equal time fixings using arithmetic average.
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
if (t>t0)
    m = floor((t-t0)/h);
else
    m = 0;
end

[EM1 EM2] = LevyMomentMatching1(S,b,sig,n,t0,tn,t)

v = sqrt(log(EM2)-2*log(EM1));

if (K-Sa*(m+1)/(n+1)<0)
    S = Sa*(m+1)/(n+1) + EM1;
    if (CP == 'c')
        call = exp(-r*tau)*(S - K);
        fprintf('The Asian call option price = %.4f\n', call);
    else
        put = 0;
        fprintf('The Asian put option price = %.4f\n', put);
    end

else

    d1 = (1/2*log(EM2)-log(K-Sa*(m+1)/(n+1))) / v;
    d2 = d1 - v;

    if CP == 'c'
        call = exp(-r*tau)*(EM1*normcdf(d1)-(K-Sa*(m+1)/(n+1))*normcdf(d2));
        fprintf('The Asian call option price = %.4f\n', call);
    else
        put = exp(-r*tau)*(EM1*(normcdf(d1)-1)-(K-Sa*(m+1)/(n+1))*(normcdf(d2)-1));
        fprintf('The Asian put option price = %.4f\n', put);
    end

end

end
