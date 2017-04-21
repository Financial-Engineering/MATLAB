function E = newSSE(z0,data,day)
% -----------------------------------------------------
% This function calculates the SSE for the
% synchronous jump model at a particular day
% in a given data set
% -----------------------------------------------------

Y = log(data(1:day,3));
r = data(1:day,6);
T = data(1:day,4);
K = data(1:day,5);
d = data(1:day,2);
state = 1;
X = [state 1-state]';

for n = 1:day
    % need to change 0 to z0(3) later
    S(n,1) = fcallprice(Y(n),K(n),r(n),z0(1),z0(2),z0(3),z0(4),z0(5)^2,T(n));
    %S(n,1) = exp(Y(n))*exp(-r(n)*T(n))*(1/2+1/pi*fintegausslege('charf1',0,500,35,Y(n),K(n),z0(1),z0(2),z0(3),z0(4),r(n),z0(5),z0(6),T(n),state))-K(n)*exp(-r(n)*T(n))*(1/2+1/pi*fintegausslege('charf2',0,500,35,Y(n),K(n),z0(1),z0(2),z0(3),z0(4),r(n),z0(5),z0(6),T(n),state));
end

E = S - d;
