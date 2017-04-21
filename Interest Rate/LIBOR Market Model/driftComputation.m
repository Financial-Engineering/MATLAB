function Drift = driftComputation(f,C,F,ti,t,tN)
% -------------------------------------------------------------------------
% Drift = driftComputation(f,C,F,ti,t,tN)
% This function computes the drifts of forward rates.
%
% Drift = output vector of drift rates.
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

A = eigenFactorise(C,F);
currentIndex = find(ti<=t);
if(length(currentIndex)==0)
    currentIndex = 0;
end
currentIndex = max(currentIndex);
if(currentIndex>=n)
    fprintf('There are no future values.\n');
    return;
end
terminalMeasureIndex = find(ti==tN);
tau = zeros(n,1);
tau(currentIndex+1) = ti(currentIndex+1)-t;
tau(currentIndex+2:n) = ti(currentIndex+2:n)-ti(currentIndex+1:n-1);
mu = zeros(n,1);
for i=currentIndex+1:n
    if(i<terminalMeasureIndex-1)
        for k=i+1:terminalMeasureIndex
            for r=1:F
                mu(i) = mu(i) + f(k)*tau(k)/(1+f(k)*tau(k))*A(i,r)*A(k,r);
            end
        end
        mu = -mu;

    elseif(i==terminalMeasureIndex-1)
        
        mu(i) = 0;
    else
        for k = terminalMeasureIndex:i
            
            for r=1:F
                mu(i) = mu(i) + f(k)*tau(k)/(1+f(k)*tau(k))*A(i,r)*A(k,r);
            end
        end
    end
end

Drift = mu;
