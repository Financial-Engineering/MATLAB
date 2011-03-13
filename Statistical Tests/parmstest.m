% OU parameters test
mu_vector = zeros(1,50);
sigma_vector = zeros(1,50);
lambda_vector = zeros(1,50);

for i = 1:50
    S = SimulateOR( S0, mu, sigma, lambda, deltaT, T);
    %S' = simulateOU(S0,  drift, speed, volatility, T);
    [ mu_vector(i), sigma_vector(i), lambda_vector(i) ] = calibrateORMaxLikelihood(S, deltaT, T);
    %[rt, parms] = calcParmsNormalMeanReverting(S);
    %mu_vector(i) = parms.drift / parms.speed;
    %lambda_vector(i) = parms.speed;
    %sigma_vector(i) = sqrt(parms.variance);
end
mu_avg = mean(mu_vector)
sigma_avg = mean(sigma_vector)
lambda_avg = mean(lambda_vector)