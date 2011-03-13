function Parameters = estimatenormalrevert(Data,M)
% -------------------------------------------------------------------------
% Parameters = estimatenormalrevert(Data,M)
% This function estimates the parameters for normal mean-reverting model.
%
% Author: Michael Shou-Cheng Lee
%
% Parameters = Output parameter values for drift, reverting speed and
%              volatility parameters.
% Data = Input data.
% M = day convention.
% -------------------------------------------------------------------------

dt = 1 / M;

for i=1:length(Data)-1
    pricechanges(i) = Data(i+1)-Data(i);
end

N = length(Data);

rbar = Data(1:length(Data)-1);
rbar = rbar(:);
pricechanges = pricechanges(:);

theta = (sum(pricechanges)*sum(rbar.^2)-...
    sum(pricechanges.*rbar)*sum(rbar))...
    /(dt*((N-1)*sum(rbar.^2)-(sum(rbar))^2));

a = (sum(pricechanges)*sum(rbar)-(N-1)*sum(pricechanges.*rbar)) / ...
    (dt*((N-1)*sum(rbar.^2)-(sum(rbar))^2));

sig = sqrt(1/((N-1)*dt)*sum((pricechanges-(theta-a.*rbar)*dt).^2));

Parameters = [theta;a;sig];
