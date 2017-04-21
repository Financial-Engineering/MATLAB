function [ y ] = CRRBinomial(S,X,T,r,b,sig,n)
    
    dt = T / n;
    u = exp(sig * sqrt(dt));
    d = 1 / u;
    p = (exp(b * dt) - d) / (u - d);
    Df = exp(-r * dt);
    
    i = 1:n+1;
    x = max(0, (S .* u .^ (i-1) .* d .^ (n+1 - i) - X));
    
    for j = n:-1:1
        for i = 1:j
            x(i) = max(((S * u ^ (i-1) * d ^ (j - i) - X)), ...
                   (p * x(i+1) + (1 - p) * x(i)) * Df);
        end
    end
    
    y = x(1);
end

