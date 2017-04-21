function f = charf2(u,Y,K,r,kappa,theta,rho,sig,v,tau)
% -----------------------------------------------------
% This is the first characteristic function for the
% Heston's model
% -----------------------------------------------------

b = sig*rho*1i*u - kappa;
a = 1i*u.*(1-1i*u);
gamma = sqrt(b.^2+a*sig^2);

D = -a.*(1-exp(-gamma*tau))./(2*gamma-(gamma+b).*(1-exp(-gamma*tau)));
C = -kappa*theta*((gamma+b)/sig^2*tau+2/sig^2*log(1-(gamma+b)./(2*gamma).*(1-exp(-gamma*tau))));

f = real((exp(-1i*u*log(K))./(1i*u)).*exp(C+D*v+1i*u*Y));

