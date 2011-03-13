function Parameter1 = estimate1(Data,M)

% -------------------------------------------------------------------------
% Parameter1 = estimate1(Data)
% This function estimates the parameters for base index.
%
% Author: Michael Shou-Cheng Lee
%
% Paramter1 = Output vector of the parameters for base index
% Data = Input vector of historical base index prices.
% M = Day convention, e.g. 365 if the day convention is 365 days in a year.
% -------------------------------------------------------------------------

pricechanges = 0;

for i=1:length(Data)-1
    pricechanges(i) = log(Data(i+1))-log(Data(i));
end

average = mean(pricechanges);
stdev = sqrt(sum((pricechanges-average).^2)/(length(pricechanges)-1));

annualisedaverage = average * M;
annualisedstdev = sqrt(stdev^2*M);

mu = annualisedaverage + annualisedstdev^2/2;
sigma = annualisedstdev;

Parameter1 = [mu sigma];
