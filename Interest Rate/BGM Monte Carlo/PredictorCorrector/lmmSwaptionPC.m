
%% Monte Carlo simulation of the LMM using the Predictor-Corrector discretisation framework

function ret = lmmSwaptionPC(P,T,alpha,beta,tau,N)

payoff_sum=0;
dt = 0.05; 
F = ForwardRate(P,tau);
rho = ComputeRho(T,beta); 
chol_rho=chol(rho); 

K=GetSwapRate(F,alpha,beta,tau); %strike of swaption is ATM swap rate

dZ = zeros(beta-1,1);
for scenario=1:N,
  scenario;
  Ffinal = MCSimulationPC(T,F,tau,dt,alpha,beta,chol_rho); 
  finalFVec=zeros(beta-1,1);
  for i=1:beta-1,
      finalFVec(i)=exp(Ffinal(i));
  end
 
  % discount factor
  df = zeros(beta-1,1);
  df(1)=1/(1+tau*finalFVec(1));
  for i=2:beta-1,
      df(i)=df(i-1)/(1+tau*finalFVec(i));
  end

  payoff=0;
  for i=alpha:beta-1,
    payoff = payoff + (K - finalFVec(i))*tau*df(i);
  end

  payoff_sum=payoff_sum+max(payoff,0);
end % scenario

swaption_price = 100*payoff_sum/N;
ret = swaption_price;



