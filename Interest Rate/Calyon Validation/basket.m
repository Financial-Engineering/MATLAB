function [P] = basket(ffs,L,K,sigb,sigG,s,df,w,F,float,TT)

% -------------------------------------------------------------------------
% function [P] = basket(ffs,L,K,sigb,sigG,df,w,F,float,TT)
%
% This program calculates the price for cancellable yield curve basket swap
% with floor.
%
% P = output vector of Non-callable and callable prices.
% ffs = 1 if it is a floating-fixed swap or 0 if it is a floating-floating
%       swap.
% L = matrix of forward LIBOR rate at each callable time.
% K = the floor level.
% sigb = vector of basket volatilities.
% sigG = vector of Geske volatilities.
% s = spread.
% df = vector of discount factors;
% w = vector of weights.
% F = fixed rate.
% float = vector of floating rate.
% TT = vector of tenor dates.
% -------------------------------------------------------------------------

TT = TT(:);
n = length(TT);
tau = [TT(1);TT(2:n)-TT(1:n-1)];
w = w(:);
for i=1:n
    bdrift(i) = sum(w.*L(:,i));
    Lb(i) = sum(w.*L(:,i));
end

V1 = 0;
V2 = 0;
fV = 0;
cV = 0;
strike = 0;
V1 = max(Lb(1),K)*df(1)*tau(1);
if(ffs==1)
    V2 = (F+s)*df(1)*tau(1);
else
    V2 = (float(1)+s)*df(1)*tau(1);
end
strike = V1;
bdrift = zeros(n,1); % This can change.
for i=2:n
    V1 = V1 + Lb(i)*df(i)*tau(i);
    fV = fV + floorlet(Lb(i),K,df(i),bdrift(i),sigb(i),TT(i-1))*tau(i);
    cV = cV + caplet(Lb(i),K,df(i),bdrift(i),sigb(i),TT(i-1))*tau(i);
    strike = strike + K*tau(i)*df(i);
    if (ffs==1)
        V2 = V2 + (F+s)*df(i)*tau(i);
    else
        V2 = V2 + (float(i)+s)*df(i)*tau(i);
    end
end
L1 = zeros(n,1);
L2 = zeros(n,1);
fvj = zeros(n,1);
for j=1:n
    for i=j+1:n
        L1(j) = L1(j) + Lb(i)*df(i)*tau(i);
        fvj(j) = fvj(j) + floorlet(Lb(i),K,df(i),bdrift(i),sigb(i),TT(i-1))*tau(i);
        if (ffs==1)
            L2(j) = L2(j) + (F+s)*df(i)*tau(i);
        else
            L2(j) = L2(j) + (float(i)+s)*df(i)*tau(i);
        end
    end
end
%L1
%L2
%sigG
%TT
L1 = [0.014162131;0.009347429;0.004626488];
L2 = [0.017413004;0.010986063;0.005137755];
GeskeSwaption = Geske(L1,L2,sigG(1:n-1),TT(1:n-1))
%GeskeSwaption = Geske(L1(1:n-1),L2(1:n-1),sigG(1:n-1),TT(1:n-1))
%V1
%V2
%fV
%cV
%strike + cV - V2
P = [V1 + fV - V2;V1 + fV - V2 + GeskeSwaption] ;
