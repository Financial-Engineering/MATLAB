function Step = oneStepSimulation(points,f,C,F,ti,t,T,tN)
% -------------------------------------------------------------------------
% Step = oneStepSimulation(points,f,C,F,ti,t,T,tN)
% This function simulate the forward rate structure for one step using
% predictor-corrector approximation.
%
% Step = vector of simulated forward rate structure.
% points = 's' if using sobol ponts; 'q' if using quasi random
% numbers.
% f = vector of forward rates.
% C = covariance matrix.
% F = number of random numbers per step.
% ti = vector of tenor time points.
% t = current time.
% T = destination point.
% tN = terminal measure time.
% -------------------------------------------------------------------------

    ti = ti(:);
    f = f(:);
    n = length(f);
    if(size(C,1)~=n || size(C,2)~=n)
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
    
    if (isempty(find(T==ti, 1)))
        fprintf('The destination point is not correct.\n');
        return;
    end
    
    if(T<=t)
        fprintf('We do not need simulation.\n');
        return;
    end
    
    if (points~='s' && points~='q')
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
    
    terminalMeasureIndex = find(ti==tN, 1);
    if(isempty(terminalMeasureIndex))
        fprintf('Inappropriate terminal measure.\n');
        return;
    end
    
    mu = driftComputation(f,C,F,ti,t,tN);
    A = eigenFactorise(C,F);
    randomnumbers = correlatedWiener(points,A,F);
    logsimulatedrates = zeros(n,1);
    logsimulatedrates = logsimulatedrates + log(f) - 1/2*diag(C)*(T-t) + mu*(T-t) + randomnumbers*sqrt(T-t);
    simulatedrates = exp(logsimulatedrates);
    muhat = driftComputation(simulatedrates,C,F,ti,t,tN);
    mu = (mu + muhat)/2;
    logsimulatedrates = zeros(n,1);
    logsimulatedrates = logsimulatedrates + log(f) - 1/2*diag(C)*(T-t) + mu*(T-t) + randomnumbers*sqrt(T-t);
    simulatedrates = exp(logsimulatedrates);
    passingIndex = T<=t;
    simulatedrates(passingIndex) = 0;
    
    for k=1:n
        if(ti(k)<T)
            simulatedrates(k) = 0;
        end
    end
    
    Step = simulatedrates;
end

