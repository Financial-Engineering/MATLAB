function f = Integrand1(S,Sc,CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,sig,sigc,ti,tc,t,T,C,index)

if(Sc<PC)
    I = 1;
else
    I = 0;
end

mu = log(S)+(bc-1/2*sigc^2)*(tc-t);
v = sqrt(sigc^2*(tc-t));
pdf = 1/(Sc*v*sqrt(2*pi))*exp(-(log(Sc)-mu)^2/(2*v^2));

%f = pdf;

if (index==1)
    f = (I*(df*N+N/K*MichaelCurran(Sc,CP,K,alp,Spg,df,r,b,sig,ti,tc,T))+(1-I)*C)*pdf;
    %f = (I*(df*N+N/K*FixedStrike('c',Sc,K,alp,Spg,df,r,b,sig,ti,tc,T))+(1-I)*C)*pdf;
else
    f = (I*(df*N+N/K*MichaelCurran(Sc,CP,K,alp,Spg,df,r,b,sig,ti,tc,T))+(1-I)*min(C,(df*N+N/K*MichaelCurran(Sc,CP,K,alp,Spg,df,r,b,sig,ti,tc,T))))*pdf;
    %f = (I*(df*N+N/K*FixedStrike('c',Sc,K,alp,Spg,df,r,b,sig,ti,tc,T))+(1-I)*min(C,(df*N+N/K*FixedStrike('c',Sc,K,alp,Spg,df,r,b,sig,ti,tc,T))))*pdf;
end
