function P = SingleWindowKO(cp,ud,S,K,H,r,c,sig,T)

% -------------------------------------------------------------------------
% P = SingleBarrierKnockOut(S,K,H,r,c,sig,t)
% this function calculates the price of single barrier knock out options.
%
% P = the price of single barrier knock out options.
% cp = 1 for a call, -1 for a put.
% ud = 1 for an up barrier, -1 for a down barrier.
% S = current stock price.
% K = strike price.
% H = the barrier.
% r = 3 by 1 vector of risk-free rates.
% c = 3 by 1 vector of convenience yields.
% sig = 3 by 1 vector of volatilities.
% T = 4 by 1 vector of times. T1 = start of window, T2 = end of
% window, T3 = expiry
% -------------------------------------------------------------------------

t=[T(2) T(3)-T(2) T(4)-T(3)];

a1 = (log(S/H)+(r(1)-c(1)+sig(1)^2/2)*t(1))/sqrt(sig(1)^2*t(1));
a2 = a1 - sqrt(sig(1)^2*t(1));

b1 = (log(S/H)+(r(1)-c(1)+sig(1)^2/2)*t(1)+(r(2)-c(2)+sig(2)^2/2)*t(2))/sqrt(sig(1)^2*t(1)+sig(2)^2*t(2));
b2 = b1 - sqrt(sig(1)^2*t(1)+sig(2)^2*t(2));

c1 = (log(S/K)+(r(1)-c(1)+sig(1)^2/2)*t(1)+(r(2)-c(2)+sig(2)^2/2)*(t(2))+(r(3)-c(3)+sig(3)^2/2)*t(3))/sqrt(sig(1)^2*t(1)+sig(2)^2*t(2)+sig(3)^2*t(3));
c2 = c1 - sqrt(sig(1)^2*t(1)+sig(2)^2*t(2)+sig(3)^2*t(3));

a3 = a1 + 2*(log(H/S)+((r(2)-c(2))*sig(1)^2/sig(2)^2+c(1)-r(1))*t(1))/sqrt(sig(1)^2*t(1));
a4 = a3 - sqrt(sig(1)^2*t(1));

b3 = b1 + 2*(log(H/S)+((r(2)-c(2))*sig(1)^2/sig(2)^2+c(1)-r(1))*t(1))/sqrt(sig(1)^2*t(1)+sig(2)^2*t(2));
b4 = b3 - sqrt(sig(1)^2*t(1)+sig(2)^2*t(2));

c3 = c1 + 2*(log(H/S)+((r(2)-c(2))*sig(1)^2/sig(2)^2+c(1)-r(1))*t(1))/sqrt(sig(1)^2*t(1)+sig(2)^2*t(2)+sig(3)^2*t(3));
c4 = c3 - sqrt(sig(1)^2*t(1)+sig(2)^2*t(2)+sig(3)^2*t(3));

rho1 = sqrt(sig(1)^2*t(1)/(sig(1)^2*t(1)+sig(2)^2*t(2)));
rho2 = sqrt(sig(1)^2*t(1)/(sig(1)^2*t(1)+sig(2)^2*t(2)+sig(3)^2*t(3)));
rho3 = sqrt((sig(1)^2*t(1)+sig(2)^2*t(2))/(sig(1)^2*t(1)+sig(2)^2*t(2)+sig(3)^2*t(3)));

sum1 = c(1)*t(1)+c(2)*t(2)+c(3)*t(3);
sum2 = r(1)*t(1)+r(2)*t(2)+r(3)*t(3);

cdf1 = tvnl([-ud*a1 -ud*b1 cp*c1],[ rho1 -cp*ud*rho2 -cp*ud*rho3],1e-14);
cdf2 = tvnl([ ud*a3 -ud*b3 cp*c3],[-rho1  cp*ud*rho2 -cp*ud*rho3],1e-14);
cdf3 = tvnl([-ud*a2 -ud*b2 cp*c2],[ rho1 -cp*ud*rho2 -cp*ud*rho3],1e-14);
cdf4 = tvnl([ ud*a4 -ud*b4 cp*c4],[-rho1  cp*ud*rho2 -cp*ud*rho3],1e-14);

P = cp*S*exp(-sum1)*(cdf1-(H/S*exp(((r(2)-c(2))*sig(1)^2/sig(2)^2+c(1)-r(1))*t(1)))^(2*(r(2)-c(2))/sig(2)^2+1)*cdf2) - ...
    cp*K*exp(-sum2)*(cdf3-(H/S*exp(((r(2)-c(2))*sig(1)^2/sig(2)^2+c(1)-r(1))*t(1)))^(2*(r(2)-c(2))/sig(2)^2-1)*cdf4);

end
