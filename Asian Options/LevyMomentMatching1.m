function [EM1,EM2] = LevyMomentMatching1(S,b,sig,n,t0,tn,t)
% -------------------------------------------------------------------------
% function [EM1,EM2] = LevyMomentMatching1(S,b,n,t0,tm,tn,t)
% This function calculates the two moments using
% Levy model.
%
% S =   the current asset price.
% b =   the cost of carry.
% sig = the volatility.
% n =   the total number of fixings minus one.
% t0 =  time to the first fixing from contract origination date.
% tn =  time to the last fixing.
% t =   the current time measured from contract initiation date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

h = (tn- t0) / n;
m = floor((t-t0)/h);
tm = t0 + m*h;
ita = (t - tm) / h;

if t >= t0
    EM1Match = S/(n+1)*exp(b*(1-ita)*h)*((1-exp(b*(n-m)*h))/(1-exp(b*h)));
    % It calculates the first moment in Levy model when t >= t0.
    
    A1 = (exp((2*b+sig^2)*h)-exp((2*b+sig^2)*(n-m+1)*h)) ... 
         / ((1-exp(b*h))*(1-exp((2*b+sig^2)*h)));
    A2 = (exp((b*(n-m+2)+sig^2)*h)-exp((2*b+sig^2)*(n-m+1)*h)) ...
         / ((1-exp(b*h))*(1-exp((b+sig^2)*h)));
    A3 = (exp((3*b+sig^2)*h)-exp((b*(n-m+2)+sig^2)*h)) ... 
         / ((1-exp(b*h))*(1-exp((b+sig^2)*h)));
    A4 = (exp(2*(2*b+sig^2)*h)-exp((2*b+sig^2)*(n-m+1)*h)) ...
         / ((1-exp((b+sig^2)*h))*(1-exp((2*b+sig^2)*h)));
    EM2Match = S^2/(n+1)^2*exp(-2*ita*(b+1/2*sig^2)*h)*(A1-A2+A3-A4);
    % It calculates the second moment of Levy model when t >= t0.
    
else
    EM1Match = S/(n+1)*exp(b*(t0-t))*(1-exp(b*(n+1)*h))/(1-exp(b*h));
    % It calculates the first moment of Levy model when t < t0.
    
    B1 = (1-exp((2*b+sig^2)*(n+1)*h)) ... 
         / ((1-exp(b*h))*(1-exp((2*b+sig^2)*h)));
    B2 = (exp(b*(n+1)*h)-exp((2*b+sig^2)*(n+1)*h)) ... 
         / ((1-exp(b*h))*(1-exp((b+sig^2)*h)));
    B3 = (exp(b*h)-exp(b*(n+1)*h)) ... 
         / ((1-exp(b*h))*(1-exp((b+sig^2)*h)));
    B4 = (exp((2*b+sig^2)*h)-exp((2*b+sig^2)*(n+1)*h)) ... 
         / ((1-exp((b+sig^2)*h))*(1-exp((2*b+sig^2)*h)));
    EM2Match = S^2/(n+1)^2*exp((2*b+sig^2)*(t0-t))*(B1-B2+B3-B4);
end

EM1 = EM1Match;
EM2 = EM2Match;

end
