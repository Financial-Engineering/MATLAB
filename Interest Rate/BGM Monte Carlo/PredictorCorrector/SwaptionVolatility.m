%% Evaluate the swaption volatility as described in (6.67) p. 283

function ret = SwaptionVolatility(F,alpha,beta,tau,T)
w = Weights(F,alpha,beta,tau);
SR = GetSwapRate(F,alpha,beta,tau);

global integrand_i;
global integrand_j;
global Tglobal;

Tglobal=T;

integrand_i=alpha;
integrand_j=alpha+1;

var_sum=0;
for i=alpha:beta-1,
  for j=alpha:beta-1,
    integrand_i=i;
    integrand_j=j;
%    area=quad('vol_integrand',0,T(alpha));
   area = quad(@vol_integrand,0,T(alpha));
    tmp1=w(i)*w(j)*F(i)*F(j)*corr(T(i),T(j));
    tmp=tmp1*area/(SR*SR);
    var_sum=var_sum+tmp;
  end
end
ret =sqrt(var_sum);
