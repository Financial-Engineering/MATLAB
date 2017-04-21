function S = swapComputation(alpha,beta,ti,F)
% --------------------------------------------------------------
% S = swapComputation(alpha,beta,ti,F)
% This function calculates the swap rate based on the linear combination
% of forward rates.
%
% S = output swap rate.
% alpha = the alpha value corresponds to the start of swap payment.
% beta = the beta value corresponds to the end of swap payment.
% ti = vector of tenor dates.
% F = vector of forward rates.
% --------------------------------------------------------------
ti = ti(:);
F = F(:);
n2 = length(ti);
n3 = length(F);
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
if (n2~=n3)
    fprintf('The tenor dimension does not match the forward rate dimension.\n');
    return;
end
summing = 0;
for i = alpha+1:beta
    summing = summing + wComputation(i,alpha,beta,F,ti)*F(i);
end

S = summing;
