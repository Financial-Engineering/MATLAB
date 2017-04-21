function P = capletPrice(points,f,K,sig,df,T,n)
% -------------------------------------------------------------------------
% P = capletPrice(points,f,K,sig,df,T,n)
% This function calculates the caplet price using simulation.
%
% P = output price.
% points = 'sobol' if using sobol points; 'quasi' if using quasi random
% numbers.
% f = forward rate.
% K = strike price.
% sig = forward rate volaitility.
% df = discount factor.
% T = time to maturity.
% n = number of simulations.
% -------------------------------------------------------------------------

if (points~='s' & points~='q')
    fprintf('points can only be sobol or quasi.\n');
    return;
end
F = 1;
t = 0;
tN = T;
simulationmatrix = zeros(n,1);
sum = 0;
for i=1:n
    rate = oneStepSimulation(points,f,sig,F,T,t,tN);
    simulationmatrix(i) = simulationmatrix(i) + max(rate-K,0);
end

P = df*mean(simulationmatrix);
