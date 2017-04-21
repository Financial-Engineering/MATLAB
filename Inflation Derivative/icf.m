function P = icf(ita,K,a,ai,sig,sigi,rho,PT1,PT2,PiT1,PiT2,T1,T2)
% -------------------------------------------------------------------------
% P = icf(ita,a,ai,sig,sigi,rho,PT1,PT2,PiT1,PiT2,T1,T2)
% This function calculates the price of inlfation caplet or floorlet.
%
% P = output price.
% ita = 1 if caplet, -1 if floorlet.
% K = strike rate.
% a = interest mean-reversion rate.
% ai = inflation mean-reversion rate.
% sig = interest volatility.
% sigi = inflation volatility.
% rho = correlation.
% PT1 = zero-coupon bond price maturing at time T1.
% PT2 = zero-coupon bond price maturing at time T2.
% PiT1 = inflation linked zero-coupon bond price maturing at time T1.
% PiT2 = inflation linked zero-coupon bond price maturing at time T2.
% -------------------------------------------------------------------------

if (ita~=1 && ita~=-1)
    fprintf('ita must be 1 or -1.\n');
    return;
end

tau = T2-T1;

V = sigi^2/ai^2*(tau-B(ai,tau)-ai/2*B(ai,tau)^2)+sigi^2*B(2*ai,tau)*B(ai,tau)^2;

C = -sigi^2/2*B(ai,T1)^2*B(ai,tau) - rho*sigi*sig/ai*B(a,tau)*(B(ai+a,T1)-B(a,T1));

IhatT1 = PiT1 / PT1;
IhatT2 = PiT2 / PT2;
S = IhatT2*exp(C)/IhatT1;

d1 = (log(S/(1+K*tau))+V/2) / sqrt(V);
d2 = (log(S/(1+K*tau))-V/2) / sqrt(V);

P = ita*PT2*(S*cnorm(ita*d1)-(1+K*tau)*cnorm(ita*d2));
