%% Two Factor Forward Curve Simulation
% A two factor Monte-Carlo model that simulates a commodity forward term
% structure based on long and short contract months.

%% CommodityForward2 
%
function [F rho]=CommodityForward(F,T,expiry,s1,s2,mu1,mu2,kappa,dt,rho,a1,a2,zeta1,zeta2,model,evolve)
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

    alpha1 = a1(expiry(1,:)); % long seasonality factor
    alpha2 = a2(expiry(1,:)); % short seasonality factor

    F = [F;zeros(length(T)-1,length(expiry))];
    
    % Iterate across contract months
   for i=1:length(expiry(2,:))
        %%
        % Time to expiry and mean reversion speed
        %
        % $$ \tau = \max{\left[\left(T_{expiry_{i}} - T\right)/365,0\right]} $$
        %
        % $$ \omega = e^{-\kappa\tau}$$
        %     
        tau = max((expiry(2,i) - T(1:end-1))/365,0);
        speed = exp(-kappa(i) .* tau);
                 
        lambda = model(mu1,mu2,speed,dt,alpha1(i),alpha2(i),s1,s2,rho,zeta1,zeta2);
               
        %% Flatten forward rates where node date >= contract expiry
        % $$ \lambda =
        % \left \{ \begin{array}{ll}{\lambda} & {\tau>0} \\ 0 & \mbox{otherwise} \end{array} \right.
        % $$
        lambda = lambda .* (tau & tau);
    
        %% Evolve the forward rate based on partial sums
        %
        % $$ F_{i}=F_{0}e^{\sum_{0}^{i}{\lambda_i}} $$
        F(2:end,i) = evolve(F(1,i),lambda);

   end

   rho = corrcoef(zeta1,zeta2);
end
