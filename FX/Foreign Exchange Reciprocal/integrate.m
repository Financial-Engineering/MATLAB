function I = integrate(f,n,a,b,CP,K,c,mu,vol)
% -------------------------------------------------------------------------
% I = integrate(f,n,mu,vol)
% This function evalutes the integral numerically 
% of a lognormal distribution with mean parameter mu and 
% volatility parameter vol using Gauss-Legendre Quadrature.
%
% f =   the function to be integrated.
% n =   number of Gauss points required.
% a =   the lower limit of the integral.
% b =   the upper limit of the integral.
% -------------------------------------------------------------------------

[x w] = gauleg(n,a,b);

I = feval(f,CP,x,K,c,mu,vol)*w';

end
