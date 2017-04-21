function flog = logfunction(x,ita,beta,u)
% -------------------------------------------------------------------------
% flog = logfunction(x,ita,beta,u)
% This function calculates the log-likelihood value at point x.
%
% flog = output log-likelihood value.
% x = vector of loss data greater than u.
% ita = ita of pareto distribution.
% beta = beta of pareto distribution.
% u = tail limit.
% -------------------------------------------------------------------------

flog = log(1/beta*(1+ita*(x-u)/beta).^(-1/ita-1));
