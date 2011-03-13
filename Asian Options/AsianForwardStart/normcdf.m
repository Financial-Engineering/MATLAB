function N = normcdf(x)

% -------------------------------------------------------------------------
% N = normcdf(x)
% Author: Michael Shou-Cheng Lee
%
% N = Output cumulative value of N(0,1)
% x = Input evaluation point
% -------------------------------------------------------------------------

N = 1/2*(1+erf(x/sqrt(2)));
