%% Basis Forward Curve Simulation
% A two factor Monte-Carlo model that simulates a commodity basis term
% structure based on long and short contract months.

%% CommodityBasisSpread 
%
function [X,F]=CommodityBasisSpread(F,P,T,expiry,dt,alpha,eta,mu,epsilon)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>S0</td><td>Initial forward rates</td></tr>
% <tr><td>P</td><td>Simulated hub forward rates</td></tr>
% <tr><td>dates</td><td>valuation dates</td></tr>
% <tr><td>expiry</td><td>contract expiry dates</td></tr>
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
% <tr><td>X</td><td>Simulated basis spread</td></tr>
% <tr><td>S</td><td>Simulated hub forward rates</td></tr>
% </table>
% </html>

    F = [F;zeros(length(T)-1,length(expiry))];
    %X = zeros(length(T)+1,length(expiry));
    X = zeros(length(T)-1,length(expiry));
    
    %%
    % Initial spread
    %
    % $$
    % X_0=\log{\frac{S_0}{P_0}}
    % $$
    %
    X(1,:) = log(F(1,:)./P(1,:));
  
    % Vector of simulation dates
    j=2:length(T);
    
    % Iterate across contract months
    for i=1:length(expiry(2,:))
        
        %%
        % Generate a vector of random movements of the forward rate
        % for each contract month:
        % 
        % $$
        % \lambda = \alpha_i\left[\mu_i-X_{j-1}\right]\Delta t+\eta_i\epsilon_{j-1}\sqrt{\Delta t}
        % $$
        lambda = alpha(i) * (mu(i) - X(j-1,i)) * dt + eta(i) * epsilon(j-1) * sqrt(dt);
 
        %% 
        % Flatten spread rates where node date >= contract expiry
        %
        % $$ X_j=X_{j-1} + \lambda \cdot \mathbf{1}_{T_{j-1} \le t_i} $$
        X(j,i) = X(j-1,i) + lambda .* (T(j-1) <= expiry(2,i));
        
        %%
        % Evolve the forward rate by adding the spread to the base rate
        % 
        % $$ F_i=P_i e^{X_i} \mbox{ or } \log{F_i}-\log{P_i}=X_i$$

        F(j,i) = P(j,i) .* exp(X(j,i));
        
    end

end
