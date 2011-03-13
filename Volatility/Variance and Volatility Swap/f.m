function v = f(S,Shat,T)
% -------------------------------------------------------------------------
% function v = f(S,Shat,T)
% This function calculates the intermediate function value.
%
% v = output function value.
% S = vector of spot price.
% Shat = vector of spot level.
% T = option maturity.
% -------------------------------------------------------------------------

v = 2/T*((S-Shat)./Shat - log(S./Shat));
