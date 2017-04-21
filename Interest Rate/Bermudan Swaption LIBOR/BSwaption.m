function P = BSwaption(points,S,f,K,C,F,ti,te,t,np)
% --------------------------------------------------------------
% P = BSwaption(points,S,f,K,C,F,ti,te,t,np)
% This function calcuates the price of Bermudan swatpion using LIBOR market
% model using Longstaff Schwartz algorithm.
%
% Step = vector of simulated forward rate structure.
% points = 's' if using sobol ponts; 'q' if using quasi random
% numbers.
% S = current spot rate.
% f = vector of forward rates.
% K = strike price.
% C = covariance matrix.
% F = number of random numbers per step.
% ti = vector of tenor time points.
% t = current time.
% te = vector of exercise time points.
% np = number of simulation paths.
% --------------------------------------------------------------

    ti = ti(:);
    f = f(:);
    n = length(f);
    
    if(length(C)~=n)
        fprintf('Dimension is not correct.\n');
        return;
    end
    
    if(length(ti)~=n)
        fprintf('Dimension is not correct.\n');
        return;
    end
    
    if(t==ti(n))
        fprintf('Current rate is at terminal point.\n');
        return;
    end
    
    if(F>n)
        fprintf('Number of random numbers per step cannot exceed dimension.\n');
        return;
    end
    
    if (points~='s' & points~='q')
        fprintf('points can only be sobol or quasi.\n');
        return;
    end
    
    currentIndex = find(ti<=t);
    
    if(isempty(currentIndex))
        currentIndex = 0;
    end
    
    currentIndex = max(currentIndex);
    
    if(currentIndex>=n)
        fprintf('There are no future values.\n');
        return;
    end
    
    tau = [ti(1);ti(2:length(ti)) - ti(1:length(ti)-1)];
    X = zeros(np,length(ti));
    Swap = zeros(np,length(ti));
    Strike = zeros(np,length(ti));
    U = zeros(np,length(ti)-1);
    fM = zeros(n,length(ti));
    Payoff = zeros(np,length(ti));
    
    for s=1:np
        for j=1:length(ti)
            fM(:,j) = oneStepSimulation(points,f,C,F,ti,t,ti(j),ti(j));
        end
        Pij = zeros(n,length(ti));
        for j=1:length(ti)
            for i=j:n
                if(i==j)
                    Pij(i,j) = 1;
                else
                    Pij(i,j) = 1;
                    for k=j:i-1
                        Pij(i,j) = Pij(i,j)*(1/(fM(k,j)*tau(k+1)+1)); %Pij is up to the last tenor date excluding the last simulated forward rate.
                    end
                end
            end
        end
        
        U(s,1) = 1;
        for j=2:length(ti)-1
            U(s,j) = Pij(j,j-1);
        end
        
        summing = 0;
        for j=1:length(ti)
            summing = 0;
            for k=j+1:length(ti)
                summing = summing + tau(k)*Pij(k,j);
            end
            for k=j+1:length(ti)
                w = tau(k)*Pij(k,j)/summing;
                Swap(s,j) = Swap(s,j) + w*fM(k-1,j);
            end
            X(s,j) = Swap(s,j)*summing;
            Strike(s,j) = K*summing;
            Payoff(s,j) = max(Swap(s,j)-K,0)*summing;
        end
    end
    
    U0 = ones(np,1)*1/(S*tau(1)+1);
    X = X(:,1:length(ti)-1);
    Strike = Strike(:,1:length(ti)-1);
    E = max(X-Strike,0);
    tk = ti(1:length(ti)-1);

    P = LS(X,U,U0,E,tk,te);
end