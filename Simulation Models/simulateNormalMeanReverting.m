function [y] = simulateNormalMeanReverting(x, z, parms)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>x</td><td>inputs</td></tr>
% <tr><td>z</td><td>correlated normal variates</td></tr>
% <tr><td>mu</td><td>drifts</td></tr>
% <tr><td>sigma_sq</td><td>variances</td></tr>
% <tr><td>h</td><td>speeds of mean reversion</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>y</td><td>simulated output values</td></tr>
% </table>
% </html>
%
%%
    mu = parms.drift;
    sigma = parms.volatility;
    h = parms.speed;
    M = 1/parms.deltaT;
    M_sqr = sqrt(M);
    
    b = mu / M + sigma / M_sqr .* z';
    a = 1 - h / M;

    % evolve
    y = evolveLinear(x, a, b); % y = ax+b
end