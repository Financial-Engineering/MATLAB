function [rt, parms] = calcParmsLognormal(rk)
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
% </table>
% </html>
%
%%
    log_rk = log(rk);
    log_rk_up = shift(log_rk, 'up');
    log_returns = log_rk_up(1:end-1,:) - log_rk(1:end-1,:);
    M = 252; % daily perturbations, on bus days only            
    means = mean(log_returns); % sample means (for each col vector)
    variances = var(log_returns); % sigma^2 - sample variances
    annualised_sds = sqrt(variances * M);
    mu = means * M + annualised_sds .^ 2 / 2;    
    sigma_sq = var(log_returns); % sigma^2 - sample variances   
 
    % outputs
    parms.drift = mu;
    parms.variance = sigma_sq;
    rt = log_returns;
end