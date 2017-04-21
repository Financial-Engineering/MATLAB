%% Price of CMS Cap
%

%% cmsCap
%
function [cp p delta gamma vega rho theta] = ...
         cmsCap(X, t0, tf, tenor, periods, rate, discRate, vol)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>X</td><td>Strike</td></tr>
% <tr><td>t0</td><td>market date</td></tr>
% <tr><td>tf</td><td>forward date</td></tr>
% <tr><td>tenor</td><td>tenor of swap rate</td></tr>
% <tr><td>periods</td><td>number of periods per year</td></tr>
% <tr><td>rate</td><td>forward yield or coupon rate</td></tr>
% <tr><td>discRate</td><td>discount rate</td></tr>
% <tr><td>vol</td><td>forward yield volatility</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>cp</td><td>price of cap</td></tr>
% <tr><td>p</td><td>vector of caplet prices</td></tr>
% <tr><td>delta</td><td>vector of caplet delta</td></tr>
% <tr><td>gamma</td><td>vector of caplet gamma</td></tr>
% <tr><td>vega</td><td>vector of caplet vega</td></tr>
% <tr><td>rho</td><td>vector of caplet rho</td></tr>
% <tr><td>theta</td><td>vector of caplet theta</td></tr>
% </table>
% </html>

    tau = diff(tf) / 365;
    tf = tf(1:end-1);

    dR = [0;discRate];
    tS = [0;cumsum(tau)];
    
    %% Generate a term structure of convexity spreads
    %
    % $$ c=-\frac{1}{2}r^2\sigma^2\tau_f\frac{F''}{F'} $$
    c = convexitySpread(t0, tf, tenor, periods, rate, vol);

    %% Add convexity spread to the base rate
    %
    rate = rate + c(:,2);

    %% Use Black-Scholes to price each caplet
    tauS = [.25/365; tS(2:end-1)];
    [p delta gamma vega rho theta] = ...
        blackscholes(1, rate, X, tauS, discRate, 0, vol);

    %% Calculate forward rates for each coupon period
    %
    % $$ \ln{fwd_i}=\Delta r_i \Delta\tau_i \Rightarrow fwd_i=e^{r_{i-1}\tau_{i-1}-r_i\tau_i} $$
    fdf = exp(dR(1:end-1) .* tS(1:end-1) - dR(2:end) .* tS(2:end));
 
    %% MTM of CMS Cap
    %
    % $$ cp=\sum_{i}{\tau_i fwd_i} $$
    p = p .* tau .* fdf;
    cp = sum(p);
end
