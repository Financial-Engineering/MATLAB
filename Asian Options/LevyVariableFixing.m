function P = LevyVariableFixing(CP,S,K,alp,Spg,r,b,sig,n,ti,t,T)
% -------------------------------------------------------------------------
% P = LevyFixEqual(S,K,alp,Spg,r,b,sig,n,ti,t,T)
% This function calculates the price of a fixed-strike
% Asian option with equal time fixings using arithmetic average.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% S =   the current asset price.
% K =   the strike price.
% alp = the array of normalised weights.
% Spg = the array of observed fixings.
% r =   the risk-free rate.
% b =   the cost of carry.
% sig = the volaitlity.
% n =   total number of fixings minus one.
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract initiation date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

if (CP ~= 'c' && CP ~= 'p')
    fprintf('Call/Put CP must be ''c'' or ''p''');
    return;
end

if(t>ti(1))
    Spg = Spg;
elseif (t==ti(1))
    Spg = S;
else
    Spg = [];
end
tau = T - t;

m = length(Spg);
if (m~=0)
    alpm = alp(1:m,:);
    Stmbar = alpm'*Spg;
else
    Stmbar = 0;
end

[EM1 EM2] = LevyVariableMoment(S,alp,Spg,b,sig,n,ti,t);

v = sqrt(log(EM2)-2*log(EM1));
if (K-Stmbar<0)
    S = Stmbar + EM1;
    if (CP == 'c')
        call = exp(-r*tau)*(S - K);
        fprintf('The Asian call option price = %.8f\n', call);
    else
        put = 0;
        fprintf('The Asian put option price = %.8f\n', put);
    end

else
    d1 = (1/2*log(EM2)-log(K-Stmbar)) / v;
    d2 = d1 - v;

    if CP == 'c'
        call = exp(-r*tau)*(EM1*normcdf(d1)-(K-Stmbar)*normcdf(d2));
        fprintf('The Asian call option price = %.8f\n', call);
    else
        put = exp(-r*tau)*(EM1*(normcdf(d1)-1)-(K-Stmbar)*(normcdf(d2)-1));
        fprintf('The Asian put option price = %.8f\n', put);
    end

end

end
