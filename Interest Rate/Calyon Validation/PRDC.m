function P = PRDC(ffs,FS,w1,w2,bl,bu,rd,rf,df,sig,L,F,TT)

% -------------------------------------------------------------------------
% function P = PRDC(ffs,FS,w1,w2,bl,bu,rd,rf,df,sig,L,F,TT)
% This function calculates the price for PRDC.
%
% P = output price.
% ffs = 1 if it is a floating-fixed swap or 0 if it is a floating-floating
%       swap.
% FS = vector of forward exchange rate.
% w1 = FX multiplier.
% w2 = FX difference rate.
% bl = floor rate.
% bu = cap rate.
% rd = vector of doemstic interest rate.
% rf = vector of foreign interest rate.
% df = vector of discount factors to the tenor dates.
% sig = vector of exchange rate volatility.
% L = vector of LIBOR rate.
% F = fixed rate.
% TT = vector of tenor dates.
% -------------------------------------------------------------------------

TT = TT(:);
n = length(TT);
tau = [TT(1);TT(2:n)-TT(1:n-1)];
V1 = 0;
V2 = 0;
fv = 0;
cv = 0;
dff = exp(-rf.*TT);
if (w1*FS(1)-w2<bu&&w1*FS(1)-w2>bl)
    %V1 = (w1*FS(1)-w2)*tau(1)*df(1);
    V1 = (w1*FS(1)-w2)*0.5*df(1);
elseif (w1*FS(1)-w2>bu)
    %V1 = bu*tau(1)*df(1);
    V1 = bu*0.5*df(1);
else
    %V1 = bl*tau(1)*df(1);
    V1 = bl*0.5*df(1);
end
if (ffs==1)
    %V2 = F*tau(1)*dff(1);
    V2 = F*0.5*dff(1);
else
    %V2 = L(1)*tau(1)*dff(1);
    V2 = L(1)*0.5*dff(1);
end
V1
V1*1000000000*0.009375146486664
fv = V1;
for i=2:n
    %fv = fv + GK('c',w1*FS(i),w2,df(i),sig(i),TT(i))*tau(i);
    GK('c',w1*FS(i),w2,df(i),sig(i),TT(i))*0.5*1000000000*0.009375146486664;
    fv = fv + GK('c',w1*FS(i),w2,df(i),sig(i),TT(i))*0.5;
    %cv = cv + GK('c',w1*FS(i),(bu+w2)/w1,rd(i),rf(i),sig(i),TT(i))*tau(i)*df(i);
    V1 = V1 + (w1*FS(i)-w2)*tau(i)*df(i);
    if (ffs==1)
        %V2 = V2 + F*tau(i)*dff(i);
        V2 = V2 + F*0.5*dff(i);
    else
        %V2 = V2 + L(i)*tau(i)*dff(i);
        V2 = V2 + L(i)*0.5*dff(i);
    end
end
%V1
V2
fv
%cv
%P = V1 + fv - cv -V2;
P = fv - V2;
