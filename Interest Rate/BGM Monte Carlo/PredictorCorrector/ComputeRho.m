% Form a correlation matrix, which represents the correlation between forward rates.

function ret = ComputeRho(T,beta)
  rho=zeros(beta-1,beta-1);
  for i=1:beta-1,
	for j=1:beta-1,
		rho(i,j)=corr(T(i),T(j));
	end
  end
  ret = rho;
  
