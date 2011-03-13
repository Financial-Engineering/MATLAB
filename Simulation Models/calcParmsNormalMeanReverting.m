function [rt, parms] = calcParmsNormalMeanReverting(rk)
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
% <tr><td>h</td><td>speeds of mean reversion</td></tr>
% </table>
% </html>
%
%%
    [num_of_observations num_of_risk_factors] = size(rk);    
    rk_up = shift(rk, 'up');
    plain_returns = rk_up(1:end-1,:) - rk(1:end-1,:);
    M = 252; % daily perturbations, on bus days only
    sigma_sq = var(plain_returns); % sigma^2 - sample variances
    returns_totals = sum(plain_returns);
    input_risk_factors_totals = sum(rk(1:end-1,:)); % only up to 251st observation
    input_risk_factors_sq_totals = sum(rk(1:end-1,:) .^ 2); % only up to 251st observation
    returns_input_risk_factors_totals = diag(plain_returns' * rk(1:end-1,:))';
    denominator = ((num_of_observations - 1) * input_risk_factors_sq_totals - input_risk_factors_totals .^ 2) / M;
    drift = (returns_totals .* input_risk_factors_sq_totals - returns_input_risk_factors_totals .* input_risk_factors_totals) ./ denominator;
    speed = (returns_totals .* input_risk_factors_totals - (num_of_observations - 1) * returns_input_risk_factors_totals) ./ denominator;
    sigma = sqrt(sum((plain_returns - (drift - speed * rk(1:end-1,:)) / M).^2) / ((num_of_observations - 1) / M));
    
    % outputs
    parms.drift = drift;
    %parms.variance = sigma_sq;
    parms.variance = sigma^2;
    parms.speed = speed;
    rt = plain_returns;
end