function y = cnorm(x)
% y = cnorm(x)
% MATH3311/MATH5335: FIle = cnorm.m
% Standard normal cumulative distribution function
%
% cnorm(x) = (1/sqrt(2*PI)) * Integral_{-infinity}^x exp(-0.5*t^2) dt
%
% using the error function erf(x).
% See normcdf in the Statistics toolbox, if that toolbox is available.

t = x / sqrt(2);

y = 0.5 * (1 + erf(t));
