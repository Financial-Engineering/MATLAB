function P = EBS(L1,L2,df1,df2,sig,TT1,TT2)
% -------------------------------------------------------------------------
% P = EBS(L1,L2,df1,df2,sig,TT1,TT2)
% This function prices the European basis swaption contract.
%
% L1 = vector of term structure of leg one floating rate.
% L2 = vector of term structure of leg two floating rate.
% df1 = vector of discount factors to leg one payment dates.
% df2 = vector of discount factors to leg two payment dates.
% sig = volatility.
% TT1 = vector of leg one tenor dates.
% TT2 = vector of leg two tenor dates.
% -------------------------------------------------------------------------

L1 = L1(:);
L2 = L2(:);
df1 = df1(:);
df2 = df2(:);
sig = sig(:);
TT1 = TT1(:);
TT2 = TT2(:);
n1 = length(TT1);
n2 = length(TT2);
T1 = TT1(2:n1) - TT1(1:n1-1);
T1 = [TT1(1);T1];
T2 = TT2(2:n2) - TT2(2:n2-1);
T2 = [TT2(1);T2];

EV1 = sum(df1.*L1.*T1);
EV2 = sum(df2.*L2.*T2);

d1 = log(EV1/EV2)/sig+1/2*sig;
d2 = d1 - sig;

P = EV1*cnorm(d1) - EV2*cnorm(d2);
