%% compute one Monte Carlo path with the LFM in the T_alpha numeraire
%% T_alpha = beginning time of the swap
%% T_0 = beginning of the swaption
%% T_alpha = maturity of the swaption, beginning of the swap
%% T_beta = maturity of the swap

%% INPUTS:
%% T = time (in years)
%% F = simply-compounded forward interest rate (1.20)
%% tau = accrual time 
%% dt = time-step of monte-carlo simulation
%% alpha = time index referring to the beginning of the swap / maturity of the swaption
%% beta = time index referring to the end of the swap
%% dZ = brownian motion ~N(0,Sigma)

function ret = MCBeginSwap(T,F,tau,dt,alpha,beta,dZ)
  t=0; %current time
  tmpcount = 1;
  logF = log(F);
  while t<=T(alpha), %simulate the path for each forward rate, till beginning of swap
      t;
      tmp_col=0;
      startk=floor(t/tau)+1;
      for k=startk:beta-1,
	drift_sum=0;
	for j=startk:k+1,
	  tmp=(corr(T(k),T(j))*tau*volatility(T(j),t)*F(j) );
	  tmp=tmp/(1+tau*F(j));
	  drift_sum = drift_sum+tmp;
	end
	tmp_col=tmp_col+1;
	sigma_Tk_t=volatility(T(k),t);

	logF(k+1)=logF(k+1)+ sigma_Tk_t*drift_sum*dt - (sigma_Tk_t*sigma_Tk_t*dt)/2 + sigma_Tk_t*dZ(tmpcount,tmp_col);
      end
      tmpcount=tmpcount+1;
      t=t+dt;
   end 
      ret = exp(logF);
end
