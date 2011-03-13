function P = AsianBasket(CP,S,K,w,alp,Spg,df,r,b,rho,sig,ti,t,T)
% -------------------------------------------------------------------------
% P = AsianBasket(CP,S,K,alp,Spg,df,r,b,rho,sig,ti,t,T)
%
% Author: Michael Shou-Cheng Lee.
%
% This function calculates the price of a Asian basket option
% with equal time fixings using arithmetic average.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% S =   the array of current asset prices.
% K =   the strike price.
% w =   the array of weights for each asset.
% alp = the array of normalised weights for fixings.
% Spg = the matrix of observed fixings.
% df = the discount factor.
% r =   the array of risk-free rates.
% b =   the matrix of cost of carries.
% sig = the matrix of volaitlities.
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract origination date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

na = length(S);
nf = length(alp);
dimensionSpg = size(Spg);
m = dimensionSpg(1,2);
dimensionb = size(b);
dimensionrho = size(rho);
dimensionsig = size(sig);

if (na ~= length(w) || na ~= dimensionb(1,1) || na ~= dimensionrho(1,1) || na ~= dimensionsig(1,1))
    fprintf('Input dimensions do not match\n');
    return;
end

Sbasket = 0;
for i = 1:na
    Sbasket = Sbasket + w(i)*S(i);
end

Spgbasket = zeros(m,1);
for k = 1:m
    for i = 1:na
        Spgbasket(k) = Spgbasket(k) + w(i)*Spg(i,k);
    end
end
Spgbasket = Spgbasket(:);

bbasket = zeros(nf,1);
for k = 1:nf
    for i = 1:na
        bbasket(k) = bbasket(k) + w(i)*b(i,k);
    end
end
bbasket = bbasket(:);

sigbasket = 0;
sigbasket1 = zeros(nf,1);
sigbasket2 = zeros(nf,1);
for k = 1:nf
    for i = 1:na
        sigbasket1(k) = sigbasket1(k) + w(i)^2*sig(i,k)^2;
        for j = 1:i-1
            sigbasket2(k) = sigbasket2(k) + 2*w(i)*w(j)*rho(i,j)*sig(i,k)*sig(j,k);
        end
    end
end
sigbasket = sqrt(sigbasket1 + sigbasket2);

Sbasket = Sbasket(:)
Kbasket = K(:)
alp = alp(:)
Spgbasket = Spgbasket(:)
df
r = r(:)
bbasket = bbasket(:)
sigbasket = sigbasket(:)
ti = ti(:)
t
T

P = FixedStrike(CP,Sbasket,K,alp,Spgbasket,df,r,bbasket,sigbasket,ti,t,T)
P = FloatingStrike1(CP,Sbasket,alp,Spgbasket,df,r,bbasket,sigbasket,ti,t,T)
