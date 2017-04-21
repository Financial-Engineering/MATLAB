t_end = T * 252;
OUSims = zeros(500,t_end);
for i=1:500
    OUSims(i,:) = SimulateOR( S0, mu, sigma, lambda, deltaT, T);
end

% mean-reverting (OU) process test
parms.mu = mu;
parms.lambda = lambda;
parms.sigma = sigma;
parms.deltaT = deltaT;
parms.T = T;
[failed failed_test expected_moments observed_moments observed_model_parms] = meanRevertingTest(1./OUSims, parms, 0.1)