function f = myfunc(p,x,u)
% -------------------------------------------------------------------------
% f = myfunc(p,x,u)
% This function calculates the sum of log-likelihood.
%
% f = output sum of log-likelihood.
% p = vector of ita and beta to be optimised.
% x = vector of loss data greater than u.
% u = tail limit.
% -------------------------------------------------------------------------

f = -sum(logfunction(x,p(1),p(2),u));
