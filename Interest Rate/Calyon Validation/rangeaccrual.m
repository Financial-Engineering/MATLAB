function P = rangeaccrual(ffs,L,Bmax,Bmin,Rfix,F,s,df1,df2,sig,ti,TT)

% -------------------------------------------------------------------------
% P = rangeaccrual(ffs,L,Bmax,Bmin,Rfix,F,s,df1,df2,sigma,TT)
%
% This function calculates the price for range accrual note.
%
% P = output price.
% ffs = 1 if it is a floating-fixed swap or 0 if it is a floating-floating
%       swap.
% L = vector of forward LIBOR rates implied by the structure on the
%     valuation date.
% Bmax = vector of upper bound.
% Bmin = vector of lower bound.
% Rfix = coupon rate.
% F = fixed rate.
% s = spread of fixed leg.
% df1 = vector of discount factors to coupon contribution dates.
% df2 = vector of discount factors to tenor dates.
% sig = vector of volatilities.
% ti = vector of coupon contribution dates.
% TT = vector of tenor dates.
% -------------------------------------------------------------------------

L = L(:);
df1 = df1(:);
df2 = df2(:);
sig = sig(:);
ti = ti(:);
TT = TT(:);
n = length(TT);
k = length(ti);
tau = [TT(1);TT(2:n)-TT(1:n-1)];
V1 = 0;
V2 = 0;
for i=1:k
    ctime = min(find(TT>=ti(i)));
    dff = df2(ctime);
    %rate = L(i)
    %bound = Bmax(i)
    %vol = sig(i)
    %tenor = ti(i)
    %digitalfloor(L(i),Bmax(i),df1(i),sig(i),ti(i))
    %dff
    %df1(i)
    %Rfix
    %tau(ctime)
    %dff/df1(i)*Rfix/365*...
        %(digitalfloor(L(i),Bmax(i),df1(i),sig(i),ti(i))-...
        %digitalfloor(L(i),Bmin(i),df1(i),sig(i),ti(i)))
    V1 = V1 + dff/df1(i)*Rfix/365*...
        (digitalfloor(L(i),Bmax(i),df1(i),sig(i),ti(i))-...
        digitalfloor(L(i),Bmin(i),df1(i),sig(i),ti(i)))*tau(ctime);
end
for j=1:n
    if (ffs==1)
        V2 = V2 + (F(j)+s)*df2(j)*tau(j);
    else
        V2 = V2 + (float(j)+s)*df2(j)*tau(j);
    end
end

P = V1 - V2;
