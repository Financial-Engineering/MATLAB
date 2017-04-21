function P = GK(cp,FS,K,df,sig,T)

% -------------------------------------------------------------------------
% P = GK(cp,FS,K,df,sig,T)
% This function calculates the foreign exchange option using
% Garman and Kohlhagen (1993) currency option model.
%
% P = output price.
% cp = 'c' if call, 'p' if put.
% FS = forward exchange rate.
% K = strike price.
% df = discount factor.
% sig = exchange rate volatility.
% T = option maturity date.
% -------------------------------------------------------------------------

d1 = (log(FS/K)+sig^2/2*T) / (sig*sqrt(T));
d2 = d1 - sig*sqrt(T);

if (cp == 'c')
    P = df*(FS*cnorm(d1) - K*cnorm(d2));
else
    P = df*(K*cnorm(-d2) - FS*cnorm(-d1));
end
