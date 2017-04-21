function SLN = simulatelognormal(random,S0,mui,sigi,dt)

% -------------------------------------------------------------------------
% SLN = simulatebase(rn,S,mui,sigi,dt)
% This function simulate the base equity index.
%
% Author: Michael Shou-Cheng Lee
%
% -------------------------------------------------------------------------

n = length(random);
S = zeros(n,2);
S(:,1) = S0;

for i=1:n
    S(i,2) = S(i,1)* ... 
        exp((mui-1/2*sigi^2)*dt+random(i)*sqrt(dt)*sigi);
end
%time = linspace(1,n,n);

%plot(time,S,'r')
%title('Base Equity 10 Years Simulated Price Path');
%xlabel('Time Point');
%ylabel('Base Index Price');

SLN = S;
