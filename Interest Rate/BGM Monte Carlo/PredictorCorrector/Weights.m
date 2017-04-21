function ret = Weights(F,alpha,beta,tau)
  denom=0;
  for k=alpha:beta-1,
    tmp=1;
    for j=alpha:k,
      tmp=tmp/(1+tau*F(j));
    end
    denom=denom+tau*tmp;
  end

  w=F*0;
  for i=alpha:beta-1,
    tmp=1;
    for j=alpha:i,
      tmp=tmp/(1+tau*F(j));
    end
    w(i)=tau*tmp/denom;
  end
  ret = w;
 
