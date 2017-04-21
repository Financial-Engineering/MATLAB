function lambda = CorrelatedTwoFactor(mu1,mu2,speed,dt,a1,a2,sig1,sig2,rho,zeta1,zeta2)

%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>F0</td><td>vector of initial forward rates</td></tr>
% <tr><td>dates</td><td>valuation dates</td></tr>
% <tr><td>expiry</td><td>contract expiry dates</td></tr>
% <tr><td>sig1,sig2</td><td>volatility of long and short contracts</td></tr>
% <tr><td>mu1,mu2</td><td>drift of long and short contracts</td></tr>
% <tr><td>kappa</td><td>speed of mean reversion</td></tr>
% <tr><td>dt</td><td>length of time slice in years</td></tr>
% <tr><td>rho</td><td>correlation between long and short contracts</td></tr>
% <tr><td>alpha1,alpha2</td><td>seasonality adjustment to long and short volatility starting at January</td></tr>
% <tr><td>eta1,eta2</td><td>long and short normal random deviants</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>F</td><td>matrix of simulated forward rates with dim(dates,expiry)</td></tr>
% </table>
% </html>

    %% Generate a vector of random movements of the forward rate for each contract month
    % 
    % $$ 
    % \lambda = \left[\mu_{1}+\mu_{2}\omega\right]\Delta t
    % -\frac{1}{2}\left[\left(\alpha_1\sigma_1\right)^2+\left(\alpha_2\sigma_2\omega\right)^2
    % +2\rho\alpha_1\sigma_1\alpha_2\sigma_2\omega\right]\Delta t
    % +\alpha_1\sigma_1\zeta_1\sqrt{\Delta
    % t}+\alpha_2\sigma_2\omega\zeta_2\sqrt{\Delta t}
    % $$
    % 

    lambda = (mu1 + mu2 .* speed) * dt ...  
        - 0.5 * ((a1 * sig1)^2 + (a2 * sig2 .* speed).^2 ...
        + 2.0 * rho * a1 * sig1 * a2 * sig2 .* speed) * dt ...
        + a1 * sig1 .* zeta1 * sqrt(dt) + a2 * sig2 .* speed .* zeta2 * sqrt(dt);
end