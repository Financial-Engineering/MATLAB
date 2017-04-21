function X = randn2(m, mu, sd, rho);
% X = randn2(m, sd, rho);
% Generate m samples from a bivariate normal density
% with mean mu and standard deviations sd and correlation rho
% mu is a vector in R^2
% sd is a vector with poisitve elements in R^2
% rho in a scalar in [-1, 1]
% 

% Standard normal variaivate in R^2
X = randn(2,m);

% Transformation, so Covariance matrix is
% C = R'*R = [sd(1)^2 rho*sd(1)*sd(2); rho*sd(1)*sd(2) sd(2)^2]
R = [sd(1) rho*sd(2); 0 sd(2)*sqrt(1-rho^2)];
X = R'*X;

% Shift mean from zero to mu in R^2
X = X + mu(:)*ones(1,m);
