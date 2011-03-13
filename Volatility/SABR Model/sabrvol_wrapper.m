% Wrapper function for (new) sabr model solving for the black's implied
% volatility
function [sigma_black] = sabrvol_wrapper(min_parms, model_parms)
    K = model_parms.K;
    nu = min_parms(1);
    beta = model_parms.beta;
    rho = min_parms(2);
    T = model_parms.T;
    F0 = model_parms.F0;
    sigma0 = model_parms.sigma0;
    sigma_black = sabrvol(K, nu, beta, rho, T, F0, sigma0);
end