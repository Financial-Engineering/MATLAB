function P = ReciprocalAverage(CP,S,K,alp,Spg,df,r,b,sig,ti,t,T)
% -------------------------------------------------------------------------
% P = ReciprocalAverage(CP,S,K,alp,Spg,df,r,b,sig,ti,t,T)
% This function calculates reciprocal Asian option price.
%
% Author: Michael Shou-Cheng Lee
%
% CP =  'c' if it is a call; 'p' if it is a put.
% S =   the current asset price.
% K =   the strike price.
% alp = the array of weights.
% Spg = the array of observed fixings.
% r =   the array of risk-free rates.
% b =   the array of cost of carries.
% sig = the array of volaitlities.
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract initiation date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

if (CP ~= 'c' && CP ~= 'p')
    fprintf('Call/Put CP must be ''c'' or ''p''\n');
    return;
end

if ((length(alp)~=length(r)) || length(alp)~=length(b) || length(alp)~=length(sig) || length(alp)~=length(ti))
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
        Spg == [];
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

if (t>=ti(length(alp)))
    if(CP=='c')
        P = max(df*(1/S-1/K),0);
    else
        P = max(df*(1/K-1/S),0);
    end
    return;
end

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
[EM1 EM2] = MomentMatching(S,alp,Spg,b,sig,ti,t)


mu = 2*log(EM1) - 1/2*log(EM2)
vol = sqrt(log(EM2)-2*log(EM1))
c = Stmbar

if CP == 'c'
    al = 0;
    bu = K - c;

    if bu > 0
        bu = bu;
    else
        bu = 0;
    end

    if(bu == 0)
        price = 0;
        P = 0;
    else
        P = df*integrate('ReciprocalIntegral',1000,al,bu,CP,K,c,mu,vol);
    end

else
    al = max(0,K-c)
    bu = EM1+10*sqrt(EM2-EM1^2)
    %integrate('ReciprocalIntegral',1000,al,bu,CP,K,c,mu,vol)
    P = df*integrate('ReciprocalIntegral',1000,al,bu,CP,K,c,mu,vol);
end
