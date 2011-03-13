function VaR = value(q,ita,beta,u,nu,n)
% -------------------------------------------------------------------------
% VaR = value(q,ita,beta,u,nu,n)
% This function calculates the VaR.
%
% VaR = output value-at-risk.
% q = confidence level.
% ita = ita parameter of pareto distribution.
% beta = beta parameter of pareto distribution.
% u = tail limit.
% nu = number of loss data greater than u.
% n = total number of loss data.
% -------------------------------------------------------------------------

VaR = u + beta/ita*((n/nu*(1-q))^-ita-1);
