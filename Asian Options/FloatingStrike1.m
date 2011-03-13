function P = FloatingStrike1(CP,S,alp,Spg,df,r,b,sig,ti,t,T)
% -------------------------------------------------------------------------
% P = FixedStrike(S,alp,Spg,df,r,b,sig,n,ti,t)
%
% Author: Michael Shou-Cheng Lee.
%
% This function calculates the price of a floating-strike
% Asian option with equal time fixings using arithmetic average.
%
% Assumption:
% t<ti(n)=T or ti(n)<t<T. 
% For t<ti(n)<T, it is a special case of DARO model.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% S =   the current asset price.
% alp = the array of normalised weights.
% Spg = the array of observed fixings.
% df = the discount factor.
% r =   the array of risk-free rates.
% b =   the array of cost of carries.
% sig = the array of volaitlities.
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract origination date.
% T = the original time to maturity
% -------------------------------------------------------------------------

if (CP ~= 'c' && CP ~= 'p')
    fprintf('Call/Put CP must be ''c'' or ''p''.\n');
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

rT = 0.056652294151436
bT = rT - 0.032
sigT = 0.0846

if (t>=ti(n))
    d1 = (log(S/Stmbar)+(bT+sigT^2/2)*(T-t))/(sigT*sqrt(T-t))
    d2 = (log(S/Stmbar)+(bT-sigT^2/2)*(T-t))/(sigT*sqrt(T-t))
    if (CP == 'c')
        P = S*exp((bT-rT)*(T-t))*normcdf(d1)-Stmbar*df*normcdf(d2);
    else
        P = Stmbar*df*normcdf(-d2)-S*exp(bT-rT)*normcdf(-d1);
    end
    return;
end

if (ti(n) < T && ti(n)>t)
    if (CP == 'c')
        beta = 1;
    else
        beta = -1;
    end
    
    K = 0;
    w1=1;
    w2=1;
    %alp1=[0;1];
    alp1=1;
    alp2=alp;
    %Spg1=S;
    Spg1=[];
    Spg2=Spg;
    %r1=[0;rT];
    r1=rT;
    r2=r;
    %b1=[-0.032;bT];
    b1=bT;
    b2=b;
    %sig1=[0.07638;sigT];
    sig1=sigT;
    sig2=sig;
    %ti1=[t;T];
    ti1=T;
    ti2=ti;
    
    P = DoubleAverageRate(beta,S,K,w1,w2,alp1,alp2,Spg1,Spg2,r1,r2,df,b1,b2,sig1,sig2,ti1,ti2,t,T);
    
    return;
end

[EM1 EM2] = MomentMatching(S,alp,Spg,b,sig,ti,t)

v = sqrt(log(EM2)-2*log(EM1));
FT = S*exp(b(n)*(T-t));
ESbarn = Stmbar + EM1

sum = 0;
for i=m+1:n
    F(i) = S*exp(b(i)*(ti(i)-t));
    sum = sum + alp(i)*F(i)*exp(sig(i)^2*(ti(i)-t));
end
v^2
sigS = sqrt(sig(n)^2*(T-t)+v^2*(EM1/(EM1+Stmbar))^2- ... 
    2*log((sum)/(EM1))*(EM1/(EM1+Stmbar)))
sigS^2
d1 = log(FT/(EM1+Stmbar))/sigS + 1/2*sigS
d2 = d1 - sigS

if (CP == 'c')
    P = df*(FT*normcdf(d1)-(EM1+Stmbar)*normcdf(d2));
else
    P = df*((EM1+Stmbar)*normcdf(-d2)-FT*normcdf(-d1));
end

end
