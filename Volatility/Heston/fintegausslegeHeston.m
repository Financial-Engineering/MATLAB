function value = fintegausslege(f,a,b,n,Y,K,r,kappa,theta,rho,sig,v,tau)
% -----------------------------------------------------
% This function evaluates the integral of a function f
% within the range a to b using the
% Gauss-Legendre Quadrature
% -----------------------------------------------------

load C75.mat;
load x75.mat;
C = C75;
x = x75;
%C = gaulegw(n,-1,1);
%x = gaulegx(n,-1,1);

upper = b;
lower = a;

% Changing the limits from [a,b] to [-1,1]
y = newx(lower, upper, x, n);

% Sum up the components to obtain the value of the integral

piece = C.*feval(f,y,Y,K,r,kappa,theta,rho,sig,v,tau) * 0.5 * (upper - lower);

clear C75;
clear x75;

summing = sum(piece);

value = summing;

end
