function W = wComputation(i,alpha,beta,F,ti)
% --------------------------------------------------------------
% W = wComputation(i,alpha,beta,ti)
% This function computes wi(0).
%
% W = output weigth.
% alpha = the alpha value corresponds to the start of swap payment.
% beta = the beta value corresponds to the end of swap payment.
% F = vector of forward rates to each of the swap tenor dates.
% ti = vector of swap tenor dates.
% --------------------------------------------------------------
F = F(:);
ti = ti(:);
n1 = length(F);
n2 = length(ti);
if (alpha>=beta)
    fprintf('Swap start date must be less than swap end date.\n');
    return;
end
if (alpha<0 || beta<0)
    fprintf('Tenor period cannot start or end on negative dates.\n');
    return;
end
if(beta>n2)
    fprintf('Swap tenor is outside the tenor dates.\n');
    return;
end
if(i<alpha+1||i>beta)
    fprintf('Weighting index does not fall inside the tenor period.\n');
    return;
end
if(n1~=n2)
    fprintf('The bond dimension does not match the tenor dimension.\n');
    return;
end
tau = [ti(1);ti(2:n2)-ti(1:n2-1)];
summing = 0;
product1 = 1;
product2 = 1;
for j = alpha+1:i
    product1 = product1 * 1/(1+tau(j)*F(j));
end
product1 = product1 * tau(i);
for k = alpha+1:beta
    for j = alpha+1:k
        product2 = product2 * 1/(1+tau(j)*F(j));
    end
    product2 = product2 * tau(k);
    summing = summing + product2;
    product2 = 1;
end

W = product1/summing;
