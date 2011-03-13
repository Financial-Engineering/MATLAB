function volatility = garch(w,a,b,S)
% -------------------------------------------------------------------------
% volatility = garch(w,a,b,S)
% This function calculates the variances using garch(1,1) model.
%
% volatility = output vector of variance.
% w = coefficient.
% a = alpha.
% b = beta.
% S = vector of stock price.
% -------------------------------------------------------------------------

u = log(S(2:length(S))./S(1:length(S)-1))
v = zeros(length(u)-1,1);
v(1) = u(1)^2;
for i=2:length(u)-1
    v(i) = w + a*u(i-1)^2 + v(i-1);
end

volatility = v;
