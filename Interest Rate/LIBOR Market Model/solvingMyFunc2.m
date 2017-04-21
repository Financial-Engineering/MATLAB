function vol = solvingMyFunc2(alpha,beta,ti,F,rho,sig,V)
% --------------------------------------------------------------
% vol = solvingMyFunc2(alpha,beta,ti,F,rho,sig,V)
% This function solves the instantaneous forward rate volatility.
%
% vol = output instantaneous forward rate volatility.
% alpha = the alpha value of the corresponding swap start date.
% beta = the beta value of the corresponding swap end date.
% ti = vector of tenor dates.
% F = vector of forward prices.
% rho = matrix of instantaneous correlation coefficients.
% sig = matrix of instantaneous forward rate volatilities.
% V = matrix of swaption volatilities.
% --------------------------------------------------------------
ti = ti(:);
F = F(:);
n2 = length(ti);
n3 = length(F);
n4 = size(rho,1);
n5 = size(rho,2);
n6 = size(sig,1);
n7 = size(sig,2);
n8 = size(V,1);
n9 = size(V,2);
if (alpha>=beta)
    fprintf('Swap start date must be less than swap end date.\n');
    return;
end
if (alpha<0 || beta<0)
    fprintf('Tenor period cannot start or end on negative dates.\n');
    return;
end
if(alpha>n2/2 || beta>n2)
    fprintf('Swap tenor is outside the tenor dates.\n');
    return;
end
if(beta<n2/2+alpha)
    fprintf('solvingMyFunc2 is not the correct function to use in this case.\n');
    return;
end
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
if (n2~=n6 || n2/2+1~=n7)
    fprintf('The tenor dates dimension does not match the forward volatility dimension.\n');
    return;
end
if (n2~=n4 || n2/2~=n8)
    fprintf('The tenor dates dimension does not match the correlation dimension.\n');
    return;
end
if (n2/2~=n8)
    fprintf('The tenor dates dimension does not match the swaption volatilities dimension.\n');
    return;
end
tau = [ti(1);ti(2:n2)-ti(1:n2-1)];
summing1 = 0;
for i = alpha+1:beta-1
    for j = alpha+1:beta-1
        innersumming1 = 0;
        for h = 1:alpha
            innersumming1 = innersumming1 + tau(h)*sig(i,h+1)*sig(j,h+1);
        end
        summing1 = summing1 + wComputation(i,alpha,beta,F,ti)*wComputation(j,alpha,beta,F,ti)*rho(i,j)*F(i)*F(j)*innersumming1;
    end
end
summing2 = 0;
for j = alpha+1:beta-1
    innersumming2 = 0;
    for h = 1:alpha-1
        innersumming2 = innersumming2 + tau(h)*sig(j,h+1);
    end
    summing2 = summing2 + wComputation(beta,alpha,beta,F,ti)*wComputation(j,alpha,beta,F,ti)*F(beta)*F(j)*rho(beta,j)*innersumming2;
end
summing2 = 2*summing2;
summing3 = 0;
for j = alpha+1:beta-1
    summing3 = summing3 + wComputation(beta,alpha,beta,F,ti)*wComputation(j,alpha,beta,F,ti)*F(beta)*F(j)*rho(beta,j)*tau(alpha)*sig(j,alpha+1);
end
summing3 = 2*summing3;
summing4 = 0;
innersumming4 = 0;
for h = 1:alpha-1
    innersumming4 = innersumming4 + tau(h);
end
summing4 = wComputation(beta,alpha,beta,F,ti)^2*F(beta)^2*innersumming4;
summing5 = 0;
summing5 = wComputation(beta,alpha,beta,F,ti)^2*F(beta)^2*tau(alpha);
summing6 = 0;
S = swapComputation(alpha,beta,ti,F);
summing6 = ti(alpha)*S^2*V(alpha,beta)^2;
%summing1
%summing2
%summing3
%summing4
%summing5
%summing6
A = summing5 + summing4;
B = summing3 + summing2;
C = summing1 - summing6;

vol = (-B + sqrt(B^2-4*A*C)) / (2*A);
