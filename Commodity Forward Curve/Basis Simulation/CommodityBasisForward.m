%% Basis Forward Curve Simulation
% A two factor Monte-Carlo model that simulates a commodity basis term
% structure based on long and short contract months.

%% CommodityBasisForward 
%
function [H,X,F] = CommodityBasisForward(P,F,T,expiry_hub,expiry_fwd,s1,s2,mu1,mu2,kappa,dt,rho,a1,a2,alpha,eta,mu,zeta1,zeta2,epsilon)

%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>F</td><td>Initial forward rates</td></tr>
% <tr><td>P</td><td>Initial hub forward rates</td></tr>
% <tr><td>T</td><td>valuation dates</td></tr>
% <tr><td>exp_hub</td><td>hub contract expiry dates</td></tr>
% <tr><td>exp_fwd</td><td>fwd contract expiry dates</td></tr>
% <tr><td>sig</td><td>volatility of long and short contracts</td></tr>
% <tr><td>mu</td><td>long term mean of ratio X</td></tr>
% <tr><td>dt</td><td>length of time slice in years</td></tr>
% <tr><td>kappa</td><td>rate of mean reversion</td></tr>
% <tr><td>eta</td><td>random deviants</td></tr>
% </table>
% </html>
%

%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>F</td><td>Simulated Hub Forward Rates</td></tr>
% <tr><td>X</td><td>Simulated Basis Spread</td></tr>
% <tr><td>H</td><td>Simulated Forward Rates</td></tr>
% </table>
% </html>
    H = CommodityForward(P,T,expiry_hub,s1,s2,mu1,mu2,kappa,dt,rho,a1,a2,zeta1,zeta2,@CorrelatedTwoFactor,@evolveMult);
    [X,F] = CommodityBasisSpread(F,H,T,expiry_fwd,dt,alpha,eta,mu,epsilon);   
end
