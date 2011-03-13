function P = estimate(x,u)
% -------------------------------------------------------------------------
% P = estimate(x,u)
% This function calculates the parameters that maximises the log-likelihood
% function.
%
% x = loss data greater than u.
% u = tail limit.
% -------------------------------------------------------------------------

P = fminsearch(@(p) myfunc(p,x,u),[0.1;0.1]);
