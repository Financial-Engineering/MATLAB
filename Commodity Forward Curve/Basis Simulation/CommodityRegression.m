%% Basis Forward Curve Simulation
% A two factor Monte-Carlo model that simulates a commodity basis term
% structure based on long and short contract months.

%% CommodityBasisSpread 
%
function [F]=CommodityRegression(F,P,dates,expiry,alpha,beta,eta,epsilon)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>F</td><td>Initial forward rates</td></tr>
% <tr><td>P</td><td>Simulated hub forward rates</td></tr>
% <tr><td>dates</td><td>valuation dates</td></tr>
% <tr><td>expiry</td><td>contract expiry dates</td></tr>
% <tr><td>alpha</td><td>hub weighting</td></tr>
% <tr><td>beta</td><td>idosyncratic risk factor weighting</td></tr>
% <tr><td>sig</td><td>volatility of long and short contracts</td></tr>
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

    F = [F;zeros(length(dates)-1,length(expiry))];
      
    % Iterate across contract months
    for i=1:length(expiry(2,:))
        
        %% 
        % Find the index where the contract expires
        %
        idx = find(expiry(2,i) < dates(2:end),1,'first');
        if isempty(idx)
            idx = length(dates);
        end
        
        %%
        % Generate a vector of random movements of the forward rate
        % for each contract month:
        % 
        % $$ F_j = \left \{ \begin{array}{ll} {P_j\left(1+\beta_i\right)+\left(\alpha_i+\eta_i\epsilon_j\right)} & {dt_j\le exp_i} \\
        % F_{j-1} & \mbox{otherwise} \end{array} \right. $$
        
        F(2:idx,i) = P(2:idx,i) .* (1 + beta(i)) + (alpha(i) + eta(i) .* epsilon(1:idx-1));
        F(idx+1:end,i) = F(idx,i);
            
    end

end
