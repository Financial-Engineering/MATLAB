function Parameters = estimatenormalrevert1(Data,M)
% -------------------------------------------------------------------------
% Parameters = estimatenormalrevert1(Data,M)
% This function estimates the parameters for normal mean-reverting model
% with zero drift.
%
% Author: Michael Shou-Cheng Lee
%
% Parameters = Output parameter values for reverting speed and
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

a = -sum(pricechanges)/(dt*sum(rbar));

sig = sqrt(1/((N-1)*dt)*sum((pricechanges+a.*rbar*dt).^2));

Parameters = [a;sig];
