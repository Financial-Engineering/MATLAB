function [parameters] = fittingvol(N,ti,t,data)
% -----------------------------------------------------------------
% [parameters] = fittingvol(N,ti,t,data)
% This function estimates the a, b, c and d using
% non-linear least square.
%
% [parameters] = output vector of parameters.
% N = number of Gauss-Legendre points.
% ti = vector of tenor dates.
% t = valuation date.
% data = Black implied volatilities.
% -----------------------------------------------------------------

ti = ti(:);
n1 = length(ti);
n2 = size(data,2);
if(n1~=n2)
    fprintf('Tenor dates mismatch in market volatilities.\n');
    return;
end
currentIndex = find(ti<=t);
if(length(currentIndex)==0)
    currentIndex = 0;
end
currentIndex = max(currentIndex);
if(currentIndex>=n1)
    fprintf('There are no future values.\n');
    return;
end
if(currentIndex~=0 & norm(data(:,1:currentIndex),inf)~=0)
    fprintf('Past volatilities are assumed to be zeros.\n');
    return;
end
x0 = [0.05 0.05 0.05 0.05];
[variables resnorm] = lsqnonlin(@(z0) errorFunction(z0,N,ti,t,data),x0,[0 0 0 0],[],optimset('Display','Iter','MaxIter',30000,'MaxFunEvals',500000));

parameters = variables;
