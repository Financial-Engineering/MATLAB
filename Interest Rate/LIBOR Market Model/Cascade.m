function [V] = Cascade(F,P,ti,rho,swap,data)
% -----------------------------------------------------------------
% [V] = Cascade(F,P,ti,rho,swap,data)
% This function calibrates the volatilities using Cascade calibration.
% This function assumes the valuation date is zero.
%
% [V] = output matrix of parameters.
% F = vector of forward rates.
% P = vector of bond prices.
% ti = vector of tenor dates.
% rho = matrix of correlation coefficeints.
% swap = matrix of swap rates.
% data = matrix of Black implied swap volatilities.
% -----------------------------------------------------------------

ti = ti(:);
n1 = length(ti);
n2 = size(data,1);
n3 = size(data,2);
n4 = size(rho,1);
n5 = size(rho,2);
n6 = length(P);
n7 = length(F);
if(n1~=n2 || n1~=n3)
    fprintf('Dimension Mismatch.\n');
    return;
end
if(n1~=n4 || n1~=n5)
    fprintf('Dimension Mismatch.\n');
    return;
end
if(n1~=n6 || n1~=n7)
    fprintf('Dimension Mismatch.\n');
    return;
end
tau = [ti(1);ti(2:n1)-ti(1:n1-1)];
vol = zeros(n1,n1);
alpha = 1;
beta = 1;
while alpha<=n1
    while beta<=n1
        W = weight(P(1:beta),ti(1:beta))
        A = W(beta)^2*F(beta)^2*tau(alpha)
        summing1 = 0;
        for j=alpha:beta-1
            summing1 = summing1 + W(beta)*W(j)*F(beta)*F(j)*rho(beta,j)*tau(alpha)*vol(j,alpha);
        end
        B = 2 * summing1
        summing2 = 0;
        for i=alpha:beta-1
            for j=alpha:beta-1
                summing2 = summing2 + W(i)*W(j)*F(i)*F(j)*rho(i,j)*tau(1)*vol(i,1)*vol(j,1);
            end
        end
        C = summing2 - ti(1)*swap(alpha,beta)^2*data(alpha,beta)^2
        vol(beta,alpha) = (-B + sqrt(B^2-4*A*C)) / (2*A);
        beta = beta + 1;
    end
    alpha = alpha + 1;
    beta = alpha;
end
vol