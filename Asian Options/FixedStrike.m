function P = FixedStrike(CP,S,K,alp,Spg,df,r,b,sig,ti,t,T)
% -------------------------------------------------------------------------
% P = FixedStrike(S,K,alp,Spg,df,r,b,sig,n,ti,t,T)
%
% Author: Michael Shou-Cheng Lee.
%
% This function calculates the price of a fixed-strike
% Asian option with equal time fixings using arithmetic average.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% S =   the current asset price.
% K =   the strike price.
% alp = the array of normalised weights.
% Spg = the array of observed fixings.
% df = the discount factor.
% r =   the array of risk-free rates.
% b =   the array of cost of carries.
% sig = the array of volaitlities.
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract origination date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

if (CP ~= 'c' && CP ~= 'p')
    fprintf('Call/Put CP must be ''c'' or ''p''.\n');
    return;
end

if (length(alp)~=length(r) || length(alp)~=length(b) || length(alp)~=length(sig) || length(alp)~=length(ti))
    fprintf('Array of inputs do not match.\n');
    return;
end

if(t>ti(1))
    if (length(Spg) == length(find(ti<=t)))
        Spg = Spg;
    else
        fprintf('Number of observed fixings mismatch the current time.\n');
        return;
    end

elseif (t==ti(1))
    if(length(Spg)==length(S) && Spg==S)
        Spg = S;
    else
        fprintf('When t==t1, we can only have the current observation.\n');
        return;
    end
else
    if (length(Spg) == 0)
        Spg = [];
    else
        fprintf('When t<t1, we cannot have any oberserved fixings.\n');
        return;
    end
end

if (ti(length(ti)) > T)
    fprintf('Fixings after option expiration is not permitted.\n');
    return;
end

if (t > T)
    fprintf('Valuation date after option exipiration is not permitted.\n');
    return;
end

if(length(Spg)~=0)
    if (t==ti(length(Spg)) && S~=Spg(length(Spg)))
        fprintf('Current asset price does not match the observed fixing.\n');
        return;
    end
end

S
K
alp
Spg
df
r
b
sig
ti
t
T

tau = T - t;
n = length(alp);

m = length(Spg);

if (m~=0)
    alpm = alp(1:m,:);
    Stmbar = alpm'*Spg;
else
    Stmbar = 0;
end
Stmbar
if (t>=ti(length(ti))) % This case requires the feed-in interest rate.
    if (CP == 'c')
        P = max(Stmbar-K*df,0);
        %P = max(df*(Stmbar*exp(0.05665)*(T-t)-K),0);
    else
        P = max(df*K-Stmbar,0);
        %P = max(df*(K-Stmbar*exp(0.05665)*(T-t)),0);
    end

else
    [EM1 EM2] = MomentMatching(S,alp,Spg,b,sig,ti,t)

    v = sqrt(log(EM2)-2*log(EM1))

    if (K-Stmbar<0)
        S = Stmbar + EM1;
        if (CP == 'c')
            P = df*(S - K);
        else
            P = 0;
        end

    else
        d1 = (1/2*log(EM2)-log(K-Stmbar)) / v
        d2 = d1 - v

        if (CP == 'c')
            P = df*(EM1*normcdf(d1)-(K-Stmbar)*normcdf(d2));
        else
            P = df*(EM1*(normcdf(d1)-1)-(K-Stmbar)*(normcdf(d2)-1));
        end

    end

end

end
