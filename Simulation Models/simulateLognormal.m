function [y] = simulateLognormal(x, z, parms)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>x</td><td>inputs</td></tr>
% <tr><td>z</td><td>correlated normal variates</td></tr>
% <tr><td>mu</td><td>drifts</td></tr>
% <tr><td>sigma</td><td>volatility</td></tr>
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
    M = 1/parms.deltaT;
    M_sqr = sqrt(M);
    b = (mu - (sigma * sigma) / 2) / M + sigma / M_sqr .* z';
    
    % evolve
    y = evolveLinear(x, 1, b); % y = x+b
end