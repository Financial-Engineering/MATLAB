t_end = T * 252;
OUSims = zeros(500,t_end);
for i=1:500
    %OUSims(i,:) = SimulateOR( S0, mu, sigma, lambda, deltaT, T);
    OUSims(i,:) = (simulateModel(S0, model_parms, T, @simulateNormalMeanReverting))';
    %OUSims(i,:) = OU_Simulate(S0, deltaT, t_end - 1, mu, sigma, lambda);
end

% mean-reverting (OU) process test
parms.mu = mu;
parms.lambda = lambda;
parms.sigma = sigma;
parms.deltaT = deltaT;
parms.T = T;
[failed failed_test expected_moments observed_moments observed_alphas observed_model_parms] = meanRevertingTest(OUSims, parms, 0.1)