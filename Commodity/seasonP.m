function [P] = seasonP(returndata,dt)

% -------------------------------------------------------------------------
% [P] = seasonP(returndata)
% This function calculates the parameters of seasonal commodity price.
%
% [P] = output vector of mean reversion rate, long term mean and volatility
% of return.
% returndata = log return of commodity prices.
% dt = time interval between observations.
% -------------------------------------------------------------------------

returndata = returndata(:);
n = length(returndata);
x = zeros(n,1);
for i=1:n
    x(i) = returndata(i)/exp(sin(4*pi*i*dt));
end
%dx = x(2:n)-x(1:n-1);
%y = dx;
%A = [ones(length(y),1) x(1:n-1)];
%alpha = A\y;
%meanrevertion = -alpha(2)/dt;
%longtermmean = alpha(1)/(meanrevertion*dt);
%error = dx - alpha(1) - alpha(2)*x(1:n-1);
%sig = std(error);
parameters = estimatelognormalrevert(x,365);
%P = [meanrevertion;longtermmean;sig];
P = [parameters(1);parameters(2);parameters(3)];
