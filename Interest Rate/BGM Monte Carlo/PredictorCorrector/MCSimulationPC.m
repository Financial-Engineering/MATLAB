%% Monte Carlo simulation of the LMM using the Predictor-Corrector discretisation schema
% T = time
% F = forward rate
% dt = time-step of monte carlo simulation
% alpha = maturity of swaption / begining of swap
% beta = maturity of swap
% chol_rho = cholesky decomposition of correlation matrix

function ret = MCSimulationPC(T,F,tau,dt,alpha,beta,chol_rho)
  curr_logF = log(F);
  curr_logF_t = log(F);
  t=0;

  % we simulate up to the maturity of the swaption (alpha numeraire)
   while(t <= T(alpha)),
    dZ = chol_rho'*randn(beta-1,1);
    
    nextResetIdx = (floor(t/tau))+1;
    for k=nextResetIdx:beta-1,
      drift_sum1=0;
      for j=nextResetIdx:k,
        tmp = corr(T(k),T(j))*tau*volatility(T(j),t)*exp(curr_logF_t(j));
        tmp = tmp / (1+tau*exp(curr_logF_t(j)));
        drift_sum1 =drift_sum1+tmp;
      end % j

      dLogF = 0;
      vol_Tk_t = volatility(T(k),t);
      dLogF = dLogF + vol_Tk_t * drift_sum1*dt;
      dLogF = dLogF - 0.5*vol_Tk_t*vol_Tk_t*dt; 
      dLogF = dLogF + vol_Tk_t*dZ(k)*sqrt(dt); 
      
      % Apply Predictor-Corrector method to recalculate drift part and take average drift part.
      drift_sum2=0;
      for j=nextResetIdx:k,
        tmp = corr(T(k),T(j))*tau*volatility(T(j),t)*exp(curr_logF_t(j) + dLogF);
        tmp = tmp / (1 + tau*exp(curr_logF_t(j)+dLogF));
        drift_sum2= drift_sum2 + tmp;
      end % j
      
      %% remove 50% of the ealier drift part
      dLogF = dLogF - 0.5*vol_Tk_t*drift_sum1*dt;
      %% add 50% of newly calculated drift based on new rate
      dLogF = dLogF + 0.5*vol_Tk_t*drift_sum2*dt;

      curr_logF(k) = curr_logF(k) + dLogF;
    end % k

    curr_logF_t = curr_logF;
    t=t + dt;    
  end % while
  
  ret = curr_logF_t;
