function p = doublebarrier2(in,cp,S,X,L,H,r,b,sigma,T)

    if cp == 1
        F = H;
    else
        F = L;
    end

    mu = 2.0 * b / (sigma * sigma) + 1;

    n=-5:5;

    d1 = (log(S * H.^(2*n) ./ (X * L.^(2*n))) + (b + (sigma * sigma) / 2.0) * T) / (sigma * sqrt(T));
    d2 = (log(S * H.^(2*n) ./ (F * L.^(2*n))) + (b + (sigma * sigma) / 2.0) * T) / (sigma * sqrt(T));
    d3 = (log(L.^(2*n + 2) ./ (X * S * H.^(2*n))) + (b + (sigma * sigma) / 2.0) * T) / (sigma * sqrt(T));
    d4 = (log(L.^(2*n + 2) ./ (F * S * H.^(2*n))) + (b + (sigma * sigma) / 2.0) * T) / (sigma * sqrt(T));

    sum1 = sum((H.^n./L.^n).^mu .* cp .*(normcdf(d1) - normcdf(d2)) - (L.^(n+1) ./ (H.^n * S)).^mu .* cp .* (normcdf(d3) - normcdf(d4)));
    sum2 = sum((H.^n./L.^n).^(mu - 2.0) .* cp .* (normcdf(d1 - sigma * sqrt(T)) - normcdf(d2 - sigma * sqrt(T))) - (L.^(n+1) ./ (H.^n * S)).^(mu - 2.0) .* cp .* (normcdf(d3 - sigma * sqrt(T)) - normcdf(d4 - sigma * sqrt(T))));

    p = cp * (S * exp((b - r) * T) * sum1 - X * exp(-r * T) * sum2);

    if (in)
        p = blackscholes(cp, S, X, T, T, r, b, sigma) - p;
    end

end
