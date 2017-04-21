function f = f1(u,F,K,kappa,theta,omega,tau,V0,rho)
   f = f2(u-1i,F,K,kappa,theta,omega,tau,V0,rho) * F;
end