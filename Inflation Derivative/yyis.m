function P = yyis(a,ai,sig,sigi,rho,PT1,PiT1,PiT2,T1,T2)
% -------------------------------------------------------------------------
% P = yyis(a,ai,sig,sigi,rho,PT1,PiT1,PiT2,T1,T2)
% This function calculates the floating leg value of the year-on-year
% inflation swap.
%
% P = output floating leg value.
% a = mean-reversion rate of interest rate.
% ai = mean-reversion rate of inflation rate.
% sig = volatility of interest rate.
% sigi = mean-reveresion rate of inflation rate.
% rho = correlation of interest rate and inflation rate.
% PT1 = zero-coupon bond price maturing at time T1.
% PiT1 = inflation linked zero-coupon bond price maturing at time T1.
% PiT2 = inflation linked zero-coupon bond price maturing at time T2.
% -------------------------------------------------------------------------

C = -sigi^2/2*B(ai,T1)^2*B(ai,T2-T1) - rho*sigi*sig/ai*B(a,T2-T1)*(B(ai+a,T1)-B(a,T1));

P = PT1*PiT2/PiT1*exp(C);
