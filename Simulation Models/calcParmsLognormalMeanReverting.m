function [rt, parms] = calcParmsLognormalMeanReverting(rk)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>rk</td><td>input risk factors</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>rt</td><td>returns</td></tr>
% <tr><td>mu</td><td>drifts</td></tr>
% <tr><td>sigma_sq</td><td>variances</td></tr>
% <tr><td>h</td><td>mean reversion speeds</td></tr>
% </table>
% </html>
%
%%
    [num_of_observations num_of_risk_factors] = size(rk);
    log_rk = log(rk);
    log_rk_up = shift(log_rk, 'up');
    log_returns = log_rk_up(1:end-1,:) - log_rk(1:end-1,:);
    M = 252; % daily perturbations, on bus days only
    sigma_sq = var(log_returns); % sigma^2 - sample variances
    returns_totals = sum(log_returns);
    input_risk_factors_totals = sum(rk(1:end-1,:)); % only up to 251st observation
    input_risk_factors_sq_totals = sum(rk(1:end-1,:) .^ 2); % only up to 251st observation
    returns_input_risk_factors_totals = diag(log_returns' * input_risk_factors(1:end-1,:))';
    denominator = ((num_of_observations - 1) * input_risk_factors_sq_totals - input_risk_factors_totals .^ 2) / M;
    mu = (returns_totals .* input_risk_factors_sq_totals - returns_input_risk_factors_totals .* input_risk_factors_totals) ./ denominator;
    h = (returns_totals .* input_risk_factors_totals - (num_of_observations - 1) * returns_input_risk_factors_totals) ./ denominator;
    
    % outputs
    parms.drift = mu;
    parms.variance = sigma_sq;
    parms.speed = h;
    rt = log_returns;
end