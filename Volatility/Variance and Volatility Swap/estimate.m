function P = estimate(S)
% -------------------------------------------------------------------------
% P = estimate(S)
% This function calculates the parameters.
%
% P = output vector of parameters.
% S = vector of stock prices.
% -------------------------------------------------------------------------

[variable, resnorm] = lsqnonlin(@(z0) myfunc(z0,S),[0.05 0.5 0.05],[],[],optimset('Display','Iter','MaxIter',30000,'MaxFunEvals',500000));

P = variable;
