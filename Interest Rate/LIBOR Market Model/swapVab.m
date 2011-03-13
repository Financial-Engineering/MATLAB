function V = swapVab(alpha,beta,ti,F,rho,sig)
% --------------------------------------------------------------
% V = swapVab(alpha,beta,ti,F,rho,sig,V)
% This function calculates the swaption volatility using Rebonato's
% formula.
%
% V = output swaption volatility.
% alpha = the alpha value of the corresponding swap start date.
% beta = the beta value of the corresponding swap end date.
% ti = vector of tenor dates.
% F = vector of forward prices.
% rho = matrix of instantaneous correlation coefficients.
% sig = matrix of instantaneous forward rate volatilities.
% --------------------------------------------------------------
ti = ti(:);
F = F(:);
n2 = length(ti);
n3 = length(F);
n4 = size(rho,1);
n5 = size(rho,2);
n6 = size(sig,1);
n7 = size(sig,2);
if (alpha>=beta)
    fprintf('Swap start date must be less than swap end date.\n');
    return;
end
if (alpha<0 || beta<0)
    fprintf('Tenor period cannot start or end on negative dates.\n');
    return;
end
if (beta-alpha > n2/2)
    fprintf('Swaption tenor is not in the tenor period.\n');
    return;
end
if(beta>n2)
    fprintf('Swap tenor is outside the tenor dates.\n');
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
if (n2~=n4)
    fprintf('The tenor dates dimension does not match the correlation dimension.\n');
    return;
end
tau = [ti(1);ti(2:n2)-ti(1:n2-1)];
summing = 0;
for i = alpha+1:beta
    for j = alpha+1:beta
        innersumming = 0;
        for h = 1:alpha
            innersumming = innersumming + tau(h)*sig(i,h+1)*sig(j,h+1);
        end
        summing = summing + wComputation(i,alpha,beta,F,ti)*wComputation(j,alpha,beta,F,ti)*F(i)*F(j)*rho(i,j)/(ti(alpha)*swapComputation(alpha,beta,ti,F)^2)*innersumming;
    end
end

V = sqrt(summing);