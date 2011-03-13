%% Compute the forward Swap Rate from T_alpha to T_beta
% alpha = time index referring to the maturity of the swaption/ beginning of the swap
% beta = time index referring to the maturity of the swap
% F = simply-compounded forward rate (vector)
% tau = accrual time
% based on (6.33) p. 239

function ret = GetSwapRate(F,alpha,beta,tau)
	tmp_sum=0;
	SR=1;
	tmp=1;
	for j=alpha+1:beta,
		tmp=tmp*(1/(1+tau*F(j-1)));
	end
	SR=1-tmp;
	for i=alpha+1:beta,
		tmp=1;
		for j=alpha+1:i,
			tmp=tmp*(1/(1+tau*F(j-1)));	  
		end
		tmp_sum=tmp_sum + (tau*tmp);
	end
	SR=SR/tmp_sum;
	ret=SR;
end
