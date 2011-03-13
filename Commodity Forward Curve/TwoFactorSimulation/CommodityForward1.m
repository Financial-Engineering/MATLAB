%% Two Factor Forward Curve Simulation
% A two factor Monte-Carlo model that simulates a commodity forward term
% structure based on long and short contract months.

%% CommodityForward 
%
function F=CommodityForward1(F,dates,expiry,sig1,sig2,mu1,mu2,kappa,dt,rho,a1,a2)
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
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>F</td><td>[dates X expiry] matrix of simulated forward rates</td></tr>
% </table>
% </html>

%% Random variables
% 
% $$\eta_1 \sim \mathcal{N}\left(\mu,\sigma^2\right)$$
% 
% $$\eta_2 \sim \mathcal{N}\left(\mu,\sigma^2\right)$$

    eta1 = randn(length(dates),1);
    eta2 = randn(length(dates),1);
    

    SIGMA = [sig1^2,rho*sig1*sig2;rho*sig1*sig2,sig2^2];
    
    zeta1 = eta1;
    zeta2 = (rho * eta1 + sqrt(1 - rho^2) * eta2);
    
    F = CommodityForward(F,T,expiry,s1,s2,mu1,mu2,kappa,dt,rho,a1,a2,zeta1,zeta2,@CorrelatedTwoFactor,@evolveMult);
end

