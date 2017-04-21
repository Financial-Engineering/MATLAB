function [ mu, sigma, lambda ] = CalibrateORLeastSquares(S, deltat) 
    if (size(S,2) > size(S,1)) 
        S = S'; 
    end
    
    [ k,~,resid ] = regress(S(2:end)-S(1:end-1),[ ones(size(S(1:end-1))) S(1:end-1) ] );
    
    a = k(1);
    b = k(2);
    
    %%
    % 
    % $$ \lambda = -\frac{\log{b}}{\Delta T} $$
    lambda = -log(b)/deltat;
    
    %%
    %
    % $$ \mu = \frac{a}{1-b} $$
    mu = a/(1-b);
    
    %%
    %
    % $$ \sigma =
    % \sigma\left(\varepsilon\right)\sqrt{\frac{2\lambda}{1-b^2}} $$
    sigma = std(resid) * sqrt( 2*lambda/(1-b^2) );
end