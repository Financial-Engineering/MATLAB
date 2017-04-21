function V = B(a,T)
% -------------------------------------------------------------------------
% V = B(a,T)
% This function calculates the function value (1-exp(-a*T))/a.
%
% V = output function value.
% a = a value.
% T = T value.
% -------------------------------------------------------------------------

V = (1-exp(-a*T)) / a;
