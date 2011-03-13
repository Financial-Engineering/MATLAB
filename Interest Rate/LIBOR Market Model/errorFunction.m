function E = errorFunction(z0,N,ti,t,data)
% -----------------------------------------------------------------
% E = errorFunction(z0,N,ti,t,data)
% This function calculates the errors of the volatilities
% from market volatilities.
%
% E = output error.
% z0 = a, b, c, d coefficients.
% N = number of Gauss-Legendre points.
% t = valuation date.
% data = Black implied caplet volatilities.
% -----------------------------------------------------------------

ti = ti(:);
n1 = size(data,1);
n2 = size(data,2);
n3 = length(ti);
if(n2~=n3)
    fprintf('Tenor dates mismatch in market volatilities.\n');
    return;
end
currentIndex = find(ti<=t);
if(length(currentIndex)==0)
    currentIndex = 0;
end
currentIndex = max(currentIndex);
if(currentIndex>=n3)
    fprintf('There are no future values.\n');
    return;
end
if(currentIndex~=0 & norm(data(:,1:currentIndex),inf)~=0)
    fprintf('Past volatilities are assumed to be zeros.\n');
    return;
end

squareerror = zeros(n2,1);
for i=1:n1
    BV = blackcapletvol(data(i,:),ti,t);
    FV = forwarddiffusionvol(N,z0(1),z0(2),z0(3),z0(4),ti,t);
    squareerror = squareerror + BV-FV;
end

E = squareerror
