function D = convertnormal(index,data,a,b,sig,dt)
% -------------------------------------------------------------------------
% D = convertnormal(index,data,a,b,sig,dt);
% This function converts data to normal.
%
% D = output normal vector.
% index = 1 if ln; 2 if nmr; 3 if lnmr.
% data = historical data.
% a = mean reversion rate.
% b = long term mean.
% sig = volatility.
% M = number of days per year.
% -------------------------------------------------------------------------

n = length(data);
if index == 1
    delta = log(data(2:n)) - log(data(1:n-1));
    D = (delta - (b-1/2*sig^2)*dt)/(sig*sqrt(dt));
elseif index == 2
    delta = data(2:n) - data(1:n-1);
    D = (delta - a*(b/a-data(1:n-1))*dt)/(sig*sqrt(dt));
elseif index == 3
    delta = log(data(2:n)) - log(data(1:n-1));
    D = (delta - a*(b/a-log(data(1:n-1)))*dt)/(sig*sqrt(dt));
else
    fprintf('Index input is not valid.\n');
end
