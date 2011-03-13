function [ y ] = CRRBinomialDD(S,X,T,r,b,sig,n,dc,DividendTimes)
    
    dt = T / n; %size of time step
    u = exp(sig * sqrt(dt)); %Up step size
    d = 1 / u; %Down step size
    p = (exp(b * dt) - d) / (u - d); %Up probability
    Df = exp(-r * dt); %Discount factor
    if u==1 
        p=0; 
    end 
    nDividends=length(dc);
    %Calculate at which steps the dividends are paid
    StepsDividend=floor(DividendTimes/dt)+1;
    
    %Declare array of discounted dividends
    CD=zeros(0,n+1);
    CD(n+1)=0;
    
    %Calculate cumulative dividend CD=D*exp(-r(t-i*dt))
    for j=n:-1:1
       for m=1:1:nDividends
          if j+1==StepsDividend(m)
            CD(j+1)=CD(j+1)+dc(m)*exp(-r*(DividendTimes(m)-j*dt));
            break;
          end
       end
       CD(j)=CD(j+1)*Df;
    end
    
    %Calculate stock value minus PV of all dividends at time zero
    So=S-CD(1);
    
    %Claculate option values at expiry
    i = 1:n+1;
    x = max(0, (So .* u .^ (i-1) .* d .^ (n+1 - i) - X));
    
    for j = n:-1:1
        for i = 1:j
            x(i) = max(((So * u ^ (i-1) * d ^ (j - i) + CD(j)- X)), ...
                   (p * x(i+1) + (1 - p) * x(i)) * Df);
        end
    end
    
    y = x(1);
end

