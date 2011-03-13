% Form a correlation matrix, which represents the correlation between forward rates.

function ret = ComputeRho(T,beta)
  rho=zeros(beta-1,beta-1);
  tmp_row=0;
  tmp_col=0;
  for i=1:beta-1,
	tmp_row=tmp_row+1;
	tmp_col=0;
	for j=1:beta-1,
		tmp_col=tmp_col+1;
		rho(tmp_row,tmp_col)=corr(T(i),T(j));
	end
  end
  ret = rho;
  
