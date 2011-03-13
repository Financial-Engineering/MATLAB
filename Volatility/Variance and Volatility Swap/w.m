function Weight = weight(ita,Shat,K,T)
% -------------------------------------------------------------------------
% Weight = weight(ita,Shat,K,T)
% This function calculates weight for each option in the portfolio.
%
% Weight = output vector of weight for each option.
% ita = 1 if call, -1 if put.
% Shat = stock level.
% K = vector of strike prices in ascending order.
% T = option time to maturity.
% -------------------------------------------------------------------------

if (ita~=1 && ita~=-1)
    fprintf('ita must be 1 or -1.\n');
    return;
end
K = K(:);
n = length(K);
w = zeros(n,1);
if (ita==-1)
    K = flipud(K);
end
ff = f(K,Shat,T);
ff = ff(:);
w(1) = (ff(2)-ff(1))/(ita*(K(2)-K(1)));
for i=2:n-1
    summing = 0;
    for j=1:i-1
        summing = summing + w(j);
    end
    summing;
    w(i) = (ff(i+1)-ff(i))/(ita*(K(i+1)-K(i))) - summing;
    summing = 0;
end

Weight = w;
