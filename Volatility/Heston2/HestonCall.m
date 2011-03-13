function P = HestonCall(S,K,V0,r,tau,mu,kappa,theta,omega,rho)
   F = S * exp(mu * tau);
   df = exp(-r * tau);
   
   f = @(u) (F * f1(u,F,K,kappa,theta,omega,tau,V0,rho) - ...
             K * f2(u,F,K,kappa,theta,omega,tau,V0,rho));
   
   P = df * (0.5 * (F - K) + (1/pi) * quadl(f,0,1000));
end
