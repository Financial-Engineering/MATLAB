function lambda = UnCorrelatedTwoFactor(mu1,mu2,speed,dt,a1,a2,sig1,sig2,rho,eta1,eta2)
        %% Generate a vector of random movements of the forward rate for each contract month
        % 
        % $$ 
        % \lambda =\left[\mu_1+\mu_2\omega\right]\Delta t-\frac{1}{2}\left[{\left(\alpha_1\sigma_1+\alpha_2\sigma_2\rho\omega\right)}^2+{\left(\alpha_2\sigma_2\sqrt{1-\rho^2}\omega\right)}^2\right]\Delta t \\ 
        % +\left[\alpha_1\sigma_1+\alpha_2\sigma_2\rho\omega\right]\varepsilon_1\sqrt{\Delta t}+\alpha_2\sigma_2\sqrt{1-\rho^2}\omega\varepsilon_2\sqrt{\Delta t}  
        % $$
        % 
        lambda = (mu1 + mu2 .* speed) * dt ...  
            - 0.5 * ((a1 * sig1 + a2 * sig2 * rho .* speed).^2 ...
            + (a2 * sig2 * sqrt(1 - rho^2) .* speed).^2) * dt ...
            + (a1 * sig1 + a2 * sig2 * rho .* speed) .* eta1 * sqrt(dt) ...
            + a2 * sig2 * sqrt(1 - rho^2) .* speed .* eta2 * sqrt(dt);
end