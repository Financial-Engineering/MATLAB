function f = pdf(x)
% -------------------------------------------------------------------------
% f = pdf(x)
% This function calculates the pdf value for a standard normal variable.
%
% f = output pdf value.
% x = input value.
% -------------------------------------------------------------------------

f = 1/sqrt(2*pi)*exp(-x^2/2);
