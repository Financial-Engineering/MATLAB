function E = myfunc(z0,S)
% -------------------------------------------------------------------------
% E = myfunc(z0,S)
% This fucntion calculates the errors of the maximum likelihood function.
%
% E = output error.
% z0 = inputs.
% S = vector of stock prices.
% -------------------------------------------------------------------------

v = garch(z0(1),z0(2),z0(3),S);
u = log(S(2:length(S))./S(1:length(S)-1));
u = u(2:length(u));

E = -sum(-log(v)-(u.^2)./v);
