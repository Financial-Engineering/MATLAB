function D = testingMyFunc2(ti,F,rho,V)
% --------------------------------------------------------------
% D = testingMyFunc2(ti,F,rho,V)
% This function tests if solvingVolMatrix2 recovers swaption matrix exactly.
%
% D = output SSE of between the market swaption matrix and solvingVolMatrix2 swaption matrix.
% ti = vector of tenor dates.
% F = vector of forward prices.
% rho = matrix of instantaneous correlation coefficients.
% V = matrix of swaption volatilities.
% --------------------------------------------------------------
ti = ti(:);
F = F(:);
n2 = length(ti);
n3 = length(F);
n4 = size(rho,1);
n5 = size(rho,2);
n8 = size(V,1);
n9 = size(V,2);
if (n2~=n3)
    fprintf('The bond dimension does not match the tenor date dimension or the forward rate dimension.\n');
    return;
end
if(norm(rho-rho',inf)~=0)
    fprintf('The correlation matrix is not symmetric.\n');
    return;
end
if (n4~=n5)
    fprintf('The correlation matrix must be square.\n');
    return;
end
if (n2~=n4)
    fprintf('The tenor dates dimension does not match the correlation dimension.\n');
    return;
end
if (n2/2~=n8 || n2~=n9)
    fprintf('The tenor dates dimension does not match the swaption volatilities dimension.\n');
    return;
end
tau = [ti(1);ti(2:n2)-ti(1:n2-1)];
sig = solvingVolMatrix2(ti,F,rho,V);
for alpha = 1:n2/2
    for beta = alpha+1:n2/2+alpha
        vol(alpha,beta) = swapVab(alpha,beta,ti,F,rho,sig);
    end
end

D = norm(V-vol,inf);
