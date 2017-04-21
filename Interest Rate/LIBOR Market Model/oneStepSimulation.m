function Step = oneStepSimulation(points,f,C,F,ti,t,tN)
% -------------------------------------------------------------------------
% Step = oneStepSimulation(points,f,C,F,ti,t,tN)
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
% tN = terminal measure time.
% -------------------------------------------------------------------------

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

mu = driftComputation(f,C,F,ti,t,tN);
A = eigenFactorise(C,F);
randomnumbers = correlatedWiener(points,A,F);
logsimulatedrates = zeros(n,1);
logsimulatedrates = logsimulatedrates + log(f) - 1/2*diag(C) + mu + randomnumbers;
simulatedrates = exp(logsimulatedrates);
muhat = driftComputation(simulatedrates,C,F,ti,t,tN);
mu = (mu + muhat)/2;
logsimulatedrates = zeros(n,1);
logsimulatedrates = logsimulatedrates + log(f) - 1/2*diag(C) + mu + randomnumbers;
simulatedrates = exp(logsimulatedrates);
passingIndex = find(ti<=t);
simulatedrates(passingIndex) = 0;

Step = simulatedrates;
