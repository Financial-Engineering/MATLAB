function ret=vol_integrand(t)
  global integrand_i;
  global integrand_j;
  global Tglobal;
  ret=volatility(Tglobal(integrand_i),t).*volatility(Tglobal(integrand_j),t);
  
