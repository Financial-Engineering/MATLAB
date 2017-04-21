function I = integrate1(f,n,S,CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,sig,sigc,sigX,rhoi,ti,tc,t,T,C,index)

%b = b - rhoi*sig*sigX;
%bc = bc - rhoi*sigc*sigX;

mu = log(S)+(bc-1/2*sigc^2)*(tc-t);
v = sqrt(sigc^2*(tc-t));
logmu = exp(mu+1/2*v^2);
logv = sqrt(exp(2*mu+v^2)*(exp(v^2)-1));

if(index == 1)
    lower1 = 0;
    upper1 = PC;
    lower2 = PC;
    upper2 = logmu + 15*logv;
    
    if (upper2<lower2)
        upper2 = lower2;
    end
    upper1 = lower2;
    
    [x1 w1] = gauleg(n,lower1,upper1);
    [x2 w2] = gauleg(n,lower2,upper2);

    sum1 = 0;
    for i=1:n
        sum1 = sum1 + feval(f,S,x1(i),CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,sig,sigc,ti,tc,t,T,C,index)*w1(i);
    end

    sum2 = 0;
    for i=1:n
        sum2 = sum2 + feval(f,S,x2(i),CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,sig,sigc,ti,tc,t,T,C,index)*w2(i);
    end
    
    I = dfc*(sum1 + sum2);
    
else
    p = findingnonsmooth(S,CP,K,alp,Spg,df,r,b,sig,ti,t,T,C,N);
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

    lower1 = 0;
    upper3 = logmu + 15*logv;
    if(upper3<lower3)
        upper3 = lower3;
    end
    
    [x1 w1] = gauleg(n,lower1,upper1);
    [x2 w2] = gauleg(n,lower2,upper2);
    [x3 w3] = gauleg(n,lower3,upper3);

    sum1 = 0;
    for i=1:n
        sum1 = sum1 + feval(f,S,x1(i),CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,sig,sigc,ti,tc,t,T,C,index)*w1(i);
    end
    
    sum2 = 0;
    for i=1:n
        sum2 = sum2 + feval(f,S,x2(i),CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,sig,sigc,ti,tc,t,T,C,index)*w2(i);
    end
    
    sum3 = 0;
    for i=1:n
        sum3 = sum3 + feval(f,S,x3(i),CP,PC,N,K,alp,Spg,dfc,df,r,b,bc,sig,sigc,ti,tc,t,T,C,index)*w3(i);
    end
    
    I = dfc*(sum1 + sum2 + sum3);
end

return;
