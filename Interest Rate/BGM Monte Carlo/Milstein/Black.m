%black price (1 year)
function ret= Black(K,Forward,v)
 d1=(log(Forward / K) + 0.5 * v * v) / v;
 d2 = d1 - v;
 Nd1=normcdf(d1);
 Nd2=normcdf(d2);

 ret=(Forward * Nd1 - K * Nd2);
 
