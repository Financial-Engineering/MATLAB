function [W] = weight(P,ti)
% --------------------------------------------------------------
% function [W] = weight(P,ti)
% This function computes the vector of weights in swap rate assuming the
% valuation date is zero.
%
% [W] = vector of output weights.
% P = vector of bond prices.
% ti = vector of swap tenor dates.
% --------------------------------------------------------------

P = P(:);
ti = ti(:);
n1 = length(P);
n2 = length(ti);
if (n1~=n2)
    fprintf('Dimension Mismatch.\n');
    return;
end

tau = [ti(1);ti(2:n1)-ti(1:n1-1)];
summing = sum(P.*tau);

W = (tau.*P)./summing;
