function [p,delta,gamma,vega,rho,theta] = blackscholes(call,S, X, Te, r, b, sigma)

    function y = cnorm(x)
        y = 0.5 * (1 + erf(x ./ sqrt(2)));
    end

    function y = cdensity(z)
        y =  1 / sqrt(2 * pi()) * exp(-z.^2 / 2);
    end

    sigma_tau_sqrt = sigma .* sqrt(Te);

    spotDF = exp((b - r) .* Te);
    strikeDF = exp(-r .* Te);
    
    F = S .* exp(b .* Te);
    
    d1 = (log(F ./ X) + (b + 0.5 .* sigma .* sigma) .* Te) ./ sigma_tau_sqrt;
    d2 = d1 -  sigma_tau_sqrt;

    if (call)
        phi = 1;
        df = spotDF;
    else
        phi = -1;
        df = strikeDF;
    end

    nd1 = cdensity(d1);
    cd1 = cnorm(phi * d1);
    cd2 = cnorm(phi * d2);
    
    p =  phi * (S .* cd1 .* spotDF - X .* cd2 .* strikeDF);

    delta = phi * df .* cd1;
    gamma = df .* nd1 ./ (S .* sigma_tau_sqrt);
    vega = S .* sqrt(Te) .* df .* nd1;
    rho = phi * X * strikeDF .* cd2;
    theta = -sigma .* S .* spotDF .* nd1 ./ (2 * sqrt(Te)) - phi * (b - r) .* S .* cd1 .* spotDF - phi * r .* X .* strikeDF .* cd2;
end
