function N = normpdf(x,u,s)

% -------------------------------------------------------------------------
% N = normpdf(x)
%
% N = Output cumulative value of N(0,1)
% x = Input evaluation point
% -------------------------------------------------------------------------

N = exp(-(x-u).^2/(2*s*s))/(s*sqrt(2*pi));
