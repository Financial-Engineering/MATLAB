function D1 = difference1(S,CP,K,alp,Spg,df,r,b,sig,ti,t,T,C,N)

%D1 = df*N+N/K*MichaelCurran(S,CP,K,alp,S,df,r,b,sig,ti,t,T) - C;
D1 = N/K*MichaelCurran(S,CP,K,alp,S,df,r,b,sig,ti,t,T)+N*df - C;
return;
