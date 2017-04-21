function MultiStep = multiStepSimulation(points,f,C,F,ti,t,tN)
% -------------------------------------------------------------------------
% MultiStep = multiStepSimulation(points,f,C,F,ti,t,tN)
% This function simulate the forward rate structure for the whole tenor
% points using predictor-corrector approximation.
%
% MultiStep = matrix of simulated forward rate structure.
% points = 's' if using sobol ponts; 'q' if using quasi random
% numbers.
% f = vector of forward rates.
% C = covariance matrix for the whole period.
% F = number of random numbers per step.
% ti = vector of tenor time points.
% t = current time.
% tN = terminal measure time.
% -------------------------------------------------------------------------
ti = ti(:);
f = f(:);
n = length(f);
Cnrow = size(C,1);
Cncolumn = size(C,2);
if(Cnrow~=n*n)
    fprintf('Dimension is not correct.\n');
end
if(Cncolumn~=n)
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
if(length(currentIndex)==0)
    currentIndex = 0;
end
currentIndex = max(currentIndex);
ratesmatrix = zeros(n,n);
Cone = C(1:n,:);
C(1:n,:) = [];
ratesmatrix(:,currentIndex+1) = oneStepSimulation(points,f,Cone,F,ti,t,tN);
for i=currentIndex+2:n
    Cone = C(1:n,:);
    C(1:n,:) = [];
    ratesmatrix(:,i) = oneStepSimulation(points,f,Cone,F,ti,ti(i-1),tN);
end

MultiStep = ratesmatrix;
