%% Convexity Adjustment of Forward rates
% 
% 

%% convexityAdjust
%
function c = convexityAdjust(F, t0, tf, periods, rate, vol)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>F</td><td>Nx2 matrix of cash flows with columns: [&tau;,N]</td></tr>
% <tr><td>t0</td><td>market date</td></tr>
% <tr><td>tf</td><td>forward date</td></tr>
% <tr><td>tau</td><td>tenor of swap rate</td></tr>
% <tr><td>periods</td><td>number of periods per year</td></tr>
% <tr><td>rate</td><td>forward yield or coupon rate</td></tr>
% <tr><td>vol</td><td>forward yield volatility</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>c</td><td>convexity adjustment for forward date tf</td></tr>
% </table>
% </html>

    %% Calculate first derivative (modified duration) of the bond cash flows
    %
    % $$ F'=\frac{\partial P}{\partial Y}=-\sum_{i=0}^{M}{\frac{\tau_i N_i}
    % {\left(1+\frac{r}{n}\right)^{\tau_i n + 1}}} $$

    d1 = - sum(F(:,1) .* F(:,2) ./ ...
             (1 + rate / periods).^(1 + F(:,1) * periods));
    
    %% Calculate second derivative (convexity) of bond cash flows     
    %
    % $$ F''=\frac{\partial^2 P}{\partial Y^2}=\sum_{i=0}^{M}{\frac{\tau_i N_i
    % \left(\tau_i N+1\right)}{N\left(1+\frac{r}{n}\right)^{\tau_i n + 2}}} $$
    d2 = sum(F(:,1) .* F(:,2) .* (F(:,1) * periods + 1) ./ ...
             (periods * (rate / periods + 1).^(F(:,1) * periods + 2)));
    
    %% Convexity correction term
    %
    % $$ c=-\frac{1}{2}r^2\sigma^2\tau_f\frac{F''}{F'} $$
    tfs = (tf - t0) / 365;
    c = -0.5 * rate^2 * vol^2 * tfs * (d2 / d1);
end