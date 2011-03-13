function I = tricdf(a,b,c,rho1,rho2)

% -------------------------------------------------------------------------
% I = tricdf(a,b,c,rho1,rho2)
% This function evaluates the trivariate normal distribution.
%
% I = the integrated value of trivariate normal distribution.
% a = the limit of the first integral.
% b = the limit of the second integral.
% c = the limit of the third integral.
% rho1 = correlation between first and second variates.
% rho2 = correlation between second and third variates.
% -------------------------------------------------------------------------

[x w] = gauleg(100,-10,b);

sum = 0;
for i=1:100
    sum = sum + bvnl((a-rho1*x(i))/sqrt(1-rho1^2),(c-rho2*x(i))/sqrt(1-rho2^2),rho1^2*rho2^2)*exp(-x(i)^2/2)*w(i);
end

I = 1/sqrt(2*pi)*sum;

end