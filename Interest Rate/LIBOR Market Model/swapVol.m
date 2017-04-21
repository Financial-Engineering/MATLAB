function SV = swapVol(N,F,P,L,S,ti,t,data)
% -----------------------------------------------------------------
% SV = swapVol(N,F,P,L,S,ti,t,data)
% This function calculates the swap volatilities using Rebonato's formula.
%
% SV = output of swap volatilities.
% N = number of Gauss-Legendre points.
% F = vector of forward LIBOR rates.
% P = vector of zero-coupon bond prices.
% L = matrix of decomposed correlation.
% S = forward swap rate covering the tenor period.
% ti = vector of tenor dates.
% t = valuation date.
% data = Black-implied volatilities.
% -----------------------------------------------------------------

F = F(:);
P = P(:);
ti = ti(:);
n1 = length(F);
n2 = length(P);
n3 = size(L,1);
n4 = size(L,2);
n5 = length(ti);
n6 = size(data,2);
if (n1~=n2 || n1~=n3 || n1~=n4 || n1~=5 || n1~=n6)
    fprintf('Dimension Mismatch.\n');
    return;
end
currentIndex = find(ti<=t);
if(length(currentIndex)==0)
    currentIndex = 0;
end
currentIndex = max(currentIndex);
if(currentIndex>=n5)
    fprintf('There are no future values.\n');
    return;
end
if(currentIndex~=0 & norm(data(:,1:currentIndex),inf)~=0)
    fprintf('Past volatilities are assumed to be zeros.\n');
    return;
end
[x w] = gauleg(N,t,ti(currentIndex+1));
tau = zeros(n,1);
tau(currentIndex+1) = ti(currentIndex+1)-t;
tau(currentIndex+2:n) = ti(currentIndex+2:n)-ti(currentIndex+1:n-1);
sumw = 0;
for k=currentIndex+1:n5
    sumw = sumw+tau(k)*P(k);
end
w0 = zeros(n5,1);
for i=currentIndex+1:n5
    w0(i) = tau(i)*P(i)/sumw;
end
swapvol = 0;
rho = L*L';
