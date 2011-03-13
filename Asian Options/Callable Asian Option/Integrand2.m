function f = Integrand2(S,Sc,Sff,CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,bf,sig,sigc,sigf,ti,tc,tff,t,T,C,index)

if(Sc<PC)
    I = 1;
else
    I = 0;
end

bcf = (bc*(tc-t)-bf*(tff-t))/(tc-tff);

sigcf = sqrt((sigc^2*(tc-t)-sigf^2*(tff-t))/(tc-tff));

mucf = log(Sff)+(bcf-1/2*sigcf^2)*(tc-tff);
vcf = sqrt(sigcf^2*(tc-tff));
condpdf = 1/(Sc*vcf*sqrt(2*pi))*exp(-(log(Sc)-mucf)^2/(2*vcf^2));

muf = log(S)+(bf-1/2*sigf^2)*(tff-t);
vf = sqrt(sigf^2*(tff-t));
pdf = 1/(Sff*vf*sqrt(2*pi))*exp(-(log(Sff)-muf)^2/(2*vf^2));

%f = condpdf*pdf;
if (index==1)
    f = (I*N/K*MichaelCurran(Sc,CP,Sff,alp,Spg,df,r,b,sig,ti,tc,T)+(1-I)*C)*condpdf*pdf;
    %f = (I*N/K*FixedStrike('c',Sc,Sff,alp,Spg,df,r,b,sig,ti,tc,T)+(1-I)*C)*condpdf*pdf;
else
    
    f = (I*N/K*MichaelCurran(Sc,CP,Sff,alp,Spg,df,r,b,sig,ti,tc,T)+(1-I)*min(C,MichaelCurran(Sc,CP,K,alp,Spg,df,r,b,sig,ti,tc,T)))*condpdf*pdf;
end
