function I = integrate2(f,n,S,CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,bf,sig,sigc,sigf,ti,tc,tff,t,T,C,index)

muf = log(S)+(bf-1/2*sigf^2)*(tff-t);
vf = sqrt(sigf^2*(tff-t));
logmuf = exp(muf+1/2*vf^2);
logvf = sqrt(exp(2*muf+vf^2)*(exp(vf^2)-1));

lowerf = 0;
upperf = logmuf + 10*logvf;

[xf wf] = gauleg(n,lowerf,upperf);

ds = 0;
for (i=1:n)
    bcf = (bc*(tc-t)-bf*(tff-t))/(tc-tff);
    sigcf = sqrt((sigc^2*(tc-t)-sigf^2*(tff-t))/(tc-tff));
    mucf = log(xf(i))+(bcf-1/2*sigcf^2)*(tc-tff);
    vcf = sqrt(sigcf^2*(tc-tff));
    logmucf = exp(mucf+1/2*vcf^2);
    logvcf = sqrt(exp(2*mucf+vcf^2)*(exp(vcf^2)-1));

    if (index == 1)
        lowerc1 = 0;
        upperc1 = PC;
        lowerc2 = PC;
        upperc2 = logmucf + 10*logvcf;
        
        if (upperc2 < lowerc2)
            lowerc2 = upperc2;
        end
        upperc1=lowerc2;
        
        [x1 w1] = gauleg(n,lowerc1,upperc1);
        [x2 w2] = gauleg(n,lowerc2,upperc2);

        sum1 = 0;
        for j=1:n
            sum1 = sum1 + feval(f,S,x1(j),xf(i),CP,PC,N,xf(i),alp,Spg,dfc,df,r,b,bc,bf,sig,sigc,sigf,ti,tc,tff,t,T,C,index)*w1(j);
        end

        sum2 = 0;
        for j=1:n
            sum2 = sum2 + feval(f,S,x2(j),xf(i),CP,PC,N,xf(i),alp,Spg,dfc,df,r,b,bc,bf,sig,sigc,sigf,ti,tc,tff,t,T,C,index)*w2(j);
        end
        
        ds(i) = (sum1 + sum2)*wf(i);

    else
        p = findingnonsmooth(S,CP,xf(i),alp,Spg,df,r,b,sig,ti,t,T,C);
        if (PC<=p)
            upper1 = PC;
            lower2 = PC;
            upper2 = p;
            lower3 = p;
        else
            upper1 = p;
            lower2 = p;
            upper2 = PC;
            lower3 = PC;
        end

        lower1 = 0
        
        upper3 = logmucf + 10*logvcf;
        [x1 w1] = gauleg(n,lower1,upper1);
        [x2 w2] = gauleg(n,lower2,upper2);
        [x3 w3] = gauleg(n,lower3,upper3);
        
        sum1 = 0;
        for j=1:n
            sum1 = sum1 + feval(f,S,x1(j),xf(i),CP,PC,N,xf(i),alp,Spg,dfc,df,r,b,bc,bf,sig,sigc,sigf,ti,tc,tff,t,T,C,index)*w1(j);
        end

        sum2 = 0;
        for j=1:n
            sum2 = sum2 + feval(f,S,x2(j),xf(i),CP,PC,N,xf(i),alp,Spg,dfc,df,r,b,bc,bf,sig,sigc,sigf,ti,tc,tff,t,T,C,index)*w2(j);
        end

        sum3 = 0;
        for j=1:n
            sum3 = sum3 + feval(f,S,x3(j),xf(i),CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,bf,sig,sigc,sigf,ti,tc,tff,t,T,C,index)*w3(j);
        end

        ds(i) = (sum1 + sum2 + sum3)*wf(i);

    end
end

I = dfc*sum(ds);

return;
