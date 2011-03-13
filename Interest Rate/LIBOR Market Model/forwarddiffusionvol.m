function FDV = forwarddiffusionvol(N,a,b,c,d,ti,t)
% -----------------------------------------------------------------
% FDV = forwarddiffusionvol(N,a,b,c,d,T,t)
% This function calculates the forward diffusion volatilities
% required in calibration using Gauss-Legendre quadrature.
%
% FDV = output vector of forward diffusion volatilities.
% N = number of quadrature points.
% a, b, c, d = coefficient constants.
% ti = vector of future tenor dates.
% t = valuation date.
% -----------------------------------------------------------------

ti = ti(:);
n = length(ti);
currentIndex = find(ti<=t);
if(length(currentIndex)==0)
    currentIndex = 0;
end
currentIndex = max(currentIndex);
if (currentIndex>=n)
    fprintf('There are no future values.\n');
    return;
end
volatilities = zeros(n,1);
for i=currentIndex+1:n
    [x,w] = gauleg(N,t,ti(i));
    for j=1:N
        volatilities(i) = volatilities(i) + w(j)*(a+(b+c*(ti(i)-x(j)))*exp(-d*(ti(i)-x(j))))^2;
    end
end
%volatilities
FDV = volatilities;
