function I=itgd(t,a,rho)
x=(a-rho.*t)./sqrt(1-rho^2);
I=normpdf(t).*normcdf(x);