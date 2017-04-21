function [EM1,EM2] = LevyMomentMatching(S,b,sig,n,t0,tn,t)
% -------------------------------------------------------------------------
% function [EM1,EM2] = LevyMomentMatching(S,b,n,t0,tm,tn,t)
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
if(t >= t0)
    ti = linspace(t0,tn,n+1);
    m = floor((t-t0)/h);
    %tm = t0 + m*h;
    %ita = (t - tm) / h;

    sum1 = 0;
    for i = m+1:n
        sum1 = sum1 + S*exp(b*(ti(i+1)-t));
    end
    sum1
    EM1Match = 1/(n+1)*sum1;

    sum2 = 0;
    for i = m+1:n
        for j = m+1:n
            sum2 = sum2 + S^2*exp(b*(ti(i+1)+ti(j+1)-2*t)+sig^2*min(ti(i+1)-t,ti(j+1)-t));
        end
    end
    EM2Match = 1/(n+1)^2*sum2;
else
    ti = linspace(t0,tn,n+1);
    sum1 = 0;
    for i = 1:n+1
        sum1 = sum1 + S*exp(b*(ti(i)-t));
    end
    EM1Match = 1/(n+1)*sum1;

    sum2 = 0;
    for i = 1:n+1
        for j = 1:n+1
            sum2 = sum2 + S^2*exp(b*(ti(i)+ti(j)-2*t)+sig^2*min(ti(i)-t,ti(j)-t));
        end
    end
    
    EM2Match = 1/(n+1)^2*sum2;
end
    %if t >= t0
    %    EM1Match = S/(n+1)*exp(b*(1-ita)*h)*((1-exp(b*(n-m)*h))/(1-exp(b*h)));
    % It calculates the first moment in Levy model when t >= t0.

    %    A1 = (exp((2*b+sig^2)*h)-exp((2*b+sig^2)*(n-m+1)*h)) ...
    %         / ((1-exp(b*h))*(1-exp((2*b+sig^2)*h)));
    %    A2 = (exp((b*(n-m+2)+sig^2)*h)-exp((2*b+sig^2)*(n-m+1)*h)) ...
    %         / ((1-exp(b*h))*(1-exp((b+sig^2)*h)));
    %    A3 = (exp((3*b+sig^2)*h)-exp((b*(n-m+2)+sig^2)*h)) ...
    %         / ((1-exp(b*h))*(1-exp((b+sig^2)*h)));
    %    A4 = (exp(2*(2*b+sig^2)*h)-exp((2*b+sig^2)*(n-m+1)*h)) ...
    %         / ((1-exp((b+sig^2)*h))*(1-exp((2*b+sig^2)*h)));
    %    EM2Match = S^2/(n+1)^2*exp(-2*ita*(b+1/2*sig^2)*h)*(A1-A2+A3-A4);
    %    % It calculates the second moment of Levy model when t >= t0.

    %else
    %    EM1Match = S/(n+1)*exp(b*(t0-t))*(1-exp(b*(n+1)*h))/(1-exp(b*h));
    % It calculates the first moment of Levy model when t < t0.

    %    B1 = (1-exp((2*b+sig^2)*(n+1)*h)) ...
    %         / ((1-exp(b*h))*(1-exp((2*b+sig^2)*h)));
    %    B2 = (exp(b*(n+1)*h)-exp((2*b+sig^2)*(n+1)*h)) ...
    %         / ((1-exp(b*h))*(1-exp((b+sig^2)*h)));
    %    B3 = (exp(b*h)-exp(b*(n+1)*h)) ...
    %         / ((1-exp(b*h))*(1-exp((b+sig^2)*h)));
    %    B4 = (exp((2*b+sig^2)*h)-exp((2*b+sig^2)*(n+1)*h)) ...
    %         / ((1-exp((b+sig^2)*h))*(1-exp((2*b+sig^2)*h)));
    %    EM2Match = S^2/(n+1)^2*exp((2*b+sig^2)*(t0-t))*(B1-B2+B3-B4);
    %end

    EM1 = EM1Match;
    EM2 = EM2Match;

end
