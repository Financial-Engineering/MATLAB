function payoff = SwaptionPayoff(F,alpha,beta,tau,K)
  SR=GetSwapRate(F,alpha,beta,tau);
  tmp_sum=0;

     % P(t,T_i) / P(t,T_alpha) (p.16)  (zero coupon bond at T_i in numeraire of T_alpha)
    for i=alpha+1:beta,
      tmp=1;
      for j=alpha+1:i,
	tmp=tmp*(1/(1+tau*F(j-1)));
      end
      tmp_sum=tmp_sum+tau*tmp; 
    end

    % discount factor df = sum_{alpha+1}^beta tau*P(T(alpha),T(i))
    df=1;
    for i=1:alpha-1,
      df=df*(1/(1+tau*F(j)));
    end
    
    payoff=df*max(SR-K,0)*tmp_sum; %(6.51)
    
