function p = doublebarrier(in,call,S,X,L,H,r,b,sigma,tau_e)

tau_d = tau_e;

delta1 = 0.0;
delta2 = 0.0;

E = L * exp(delta1 * tau_e);
F = H * exp(delta1 * tau_e);

sum1 = 0.0;
sum2 = 0.0;

if (call)
    for n = -5:5
        d1 = (log(S * H^(2*n) / (X * L^(2*n))) + (b + (sigma * sigma) / 2.0) * tau_e) / (sigma * sqrt(tau_e));
        d2 = (log(S * H^(2*n) / (F * L^(2*n))) + (b + (sigma * sigma) / 2.0) * tau_e) / (sigma * sqrt(tau_e));
        d3 = (log(L^(2*n+2) / (X * S * H^(2*n))) + (b + (sigma * sigma) / 2.0) * tau_e) / (sigma * sqrt(tau_e));
        d4 = (log(L^(2*n+2) / (F * S * H^(2*n))) + (b + (sigma * sigma) / 2.0) * tau_e) / (sigma * sqrt(tau_e));

        mu1 = 2.0 * (b - delta2 - n * (delta1 - delta2)) / (sigma * sigma) + 1;
        mu2 = 2.0 * n * (delta1 - delta2) / (sigma * sigma);
        mu3 = 2.0 * (b - delta2 + n * (delta1 - delta2)) / (sigma * sigma) + 1;

        sum1 = sum1 + (H^n/L^n)^mu1 * (L/S)^mu2 * (normcdf(d1) - normcdf(d2)) - (L^(n+1) / (H^n * S))^mu3 * (normcdf(d3) - normcdf(d4));
        sum2 = sum2 + (H^n/L^n)^(mu1-2) * (L/S)^mu2 * (normcdf(d1 - sigma * sqrt(tau_e)) - normcdf(d2 - sigma * sqrt(tau_e))) - (L^(n+1) / (H^n * S))^(mu3 - 2.0) * (normcdf(d3 - sigma * sqrt(tau_e)) - normcdf(d4 - sigma * sqrt(tau_e)));
    end
    p = S * exp((b-r) * tau_e) * sum1 - X * exp(-r * tau_e) * sum2;

else
    for n = -5:5
        d1 = (log(S * H^(2*n) / (E * L^(2*n))) + (b + (sigma * sigma) / 2.0) * tau_e) / (sigma * sqrt(tau_e));
        d2 = (log(S * H^(2*n) / (X * L^(2*n))) + (b + (sigma * sigma) / 2.0) * tau_e) / (sigma * sqrt(tau_e));
        d3 = (log(L^(2*n+2) / (E * S * H^(2*n))) + (b + (sigma * sigma) / 2.0) * tau_e) / (sigma * sqrt(tau_e));
        d4 = (log(L^(2*n+2) / (X * S * H^(2*n))) + (b + (sigma * sigma) / 2.0) * tau_e) / (sigma * sqrt(tau_e));

        mu1 = 2.0 * (b - delta2 - n * (delta1 - delta2)) / (sigma * sigma) + 1;
        mu2 = 2.0 * n * (delta1 - delta2) / (sigma * sigma);
        mu3 = 2.0 * (b - delta2 + n * (delta1 - delta2)) / (sigma * sigma) + 1;

        sum1 = sum1 + (H^n/L^n)^mu1 * (L/S)^mu2 * (normcdf(d1) - normcdf(d2)) - (L^(n+1) / (H^n * S))^mu3 * (normcdf(d3) - normcdf(d4));
        sum2 = sum2 + (H^n/L^n)^(mu1-2) * (L/S)^mu2 * (normcdf(d1 - sigma * sqrt(tau_e)) - normcdf(d2 - sigma * sqrt(tau_e))) - (L^(n+1) / (H^n * S))^(mu3 - 2.0) * (normcdf(d3 - sigma * sqrt(tau_e)) - normcdf(d4 - sigma * sqrt(tau_e)));
    end
    p = X * exp(-r * tau_e) * sum2 - S * exp((b-r) * tau_e) * sum1;
end

if (in)
    p = blackscholes(call, S, X, tau_e, tau_d, r, b, sigma) - p;
end

end
