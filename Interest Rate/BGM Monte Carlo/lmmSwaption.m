function ret = lmmSwaption(P,T,alpha,beta,tau,N)

dt = 1;
F = ForwardRate(P,tau);
rho = ComputeRho(T,beta);

chol_rho=chol(rho);
chol_rho;
K=GetSwapRate(F,alpha,beta,tau); %strike of swaption is ATM swap rate

payoff_sum=0;
flag_antithetic=-1;

for scenario=1:N,
  scenario
  cases=T(alpha)/dt; %only the forward rates within swap need to be simulated
  if flag_antithetic == -1, %use antithetic MC
     dZ = BrownianMotionGenerator(chol_rho, cases+10, size(rho,1),dt);
  else
     dZ=-dZ;
  endif
  flag_antithetic=flag_antithetic*-1;
  Ffinal = MCBeginSwap(T,F,tau,dt,alpha,beta,dZ);
  payoff = SwaptionPayoff(Ffinal,alpha,beta,tau,K);
  payoff_sum=payoff_sum+payoff;	% sum up the payoff for each scenario
end 

payoff=payoff_sum/N; % average -> E(payoff)
swaption_price=payoff*100;
swaptionVol = SwaptionVolatility(F,alpha,beta,tau,T); % volatility different from parametric vol. -> bad comparison Black-MC

tmpsum=0;
for i=alpha:beta-1,
 tmpsum=tmpsum+tau*P(i+1);
end

black_swaption_price=tmpsum*Black(K,K,swaptionVol)*100;

ret = [swaption_price black_swaption_price];

end

