function D2 = difference2(S,CP,K,alp,Spg,df,r,b,sig,ti,t,T,C,N)

%D2 = df*N+N/K*MichaelCurran(S,CP,K,alp,Spg,df,r,b,sig,ti,t,T) - C;
D2 = N/K*MichaelCurran(S,CP,K,alp,Spg,df,r,b,sig,ti,t,T)+df*N - C;
return;