function f = MichaelCurran(CP,S,K,alp,Spg,df,r,b,sig,ti,t,T)

% -------------------------------------------------------------------------
% f = MichaelCurran(CP,S,K,alp,Spg,df,r,b,sig,ti,t,T)
%
% Author: Michael Shou-Cheng Lee.
%
% This function calculates the price of a fixed-strike
% Asian option with equal time fixings using arithmetic average
% Michael Curran's Model.
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

nf = length(alp);
r = r(:);
W = sum(alp);

m = 0;
for i=1:nf
    m(i) = log(S)+b(i)*(ti(i)-t)-1/2*sig(i)^2*(ti(i)-t);
end
m = m(:);

rho=0;
for i=1:nf
    for j=i:nf
        rho(i,j) = sqrt(sig(i)^2*(ti(i)-t)/(sig(j)^2*(ti(j)-t)));
        rho(j,i) = rho(i,j);
    end
end
rho
alp
m
msum = 1/W*alp'*m

sigA2 = 0;
for i=1:nf
    for j=1:nf
        sigA2 = sigA2 + alp(i)*alp(j)*sig(i)*sig(j)*rho(i,j);
    end
end
sigA2 = 1/W^2*sigA2;

sigA = sqrt(sigA2)
1/W

bigsum = 0;
innersum = 0;
for i=1:nf
    for j=1:nf
        innersum = innersum + alp(j)*rho(i,j)*sig(j);
    end
    bigsum = bigsum + 1/W*(alp(i)*exp(m(i)+1/2*sig(i)^2))* ... 
        normcdf((msum-log(K))/sigA+(sig(i)/W)*innersum/sigA);
end

callprice = df*(bigsum-K*normcdf((msum-log(K))/sigA));

smallsum = 0;
for i=1:nf
    smallsum = smallsum + alp(i)*exp(b(i)*(ti(i)-t));
end

putprice = callprice + df*(K-1/W*smallsum);

if (CP=='c')
    f = callprice;
else
    f = putprice;
end

end
