function P = ioption(ita,K,ai,sigi,PT,IT0,PiT,T)
% -------------------------------------------------------------------------
% P = ioption(ita,K,ai,sigi,PT,IT0,PiT,T)
% This function calculates the price of an inflation option.
%
% P = output price.
% ita = 1 if call, -1 if put.
% K = strike rate.
% ai = inlfation mean-reversion rate.
% sigi = volatility of inflation rate.
% PT = zero-coupon bond price maturing at time T.
% IT0 = base inflation index.
% PiT = inflation linked zero-coupon bond price maturing at time T.
% T = option maturity date.
% -------------------------------------------------------------------------

if (ita~=1 && ita~=-1)
    fprintf('ita needs to be 1 or -1.\n');
    return;
end

V = sigi^2/ai^2*(T-B(ai,T)-ai/2*B(ai,T)^2);

d1 = (log(PiT/(IT0*PT*K))+V/2) / sqrt(V);
d2 = (log(PiT/(IT0*PT*K))-V/2) / sqrt(V);

P = ita*(PiT/IT0*cnorm(ita*d1)-K*PT*cnorm(ita*d2));
