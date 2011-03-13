% Simulate OU paths
% Source: http://formulapages.com/doc/Ornstein-Uhlenbeck_process
function S = OU_Simulate(S0, dT, n, mu, sigma, lambda)
    a = exp(-lambda*dT);
    b = mu*(1-a);
    c = sigma*sqrt((1-a*a)/2/lambda);
    S = [S0 filter(1,[1 -a], b+c*randn(1,n), a*S0)];
end
