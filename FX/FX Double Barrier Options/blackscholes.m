function [p,delta,gamma,vega] = blackscholes(call,S, X, Te, Td, r, b, sigma)

sigma_tau_sqrt = sigma * sqrt(Te);

F = S * exp(b * Td);

d1 = (log(F / X) + 0.5 * sigma * sigma * Te) / sigma_tau_sqrt;
d2 = d1 -  sigma_tau_sqrt;

if (call)
    phi = 1;
else
    phi = -1;
end

df_for = exp((b - r) * Td);
p = phi * df_for * (S * normcdf(phi * d1) - X * normcdf(phi * d2));

delta = phi * df_for * normcdf(phi * d1);
gamma = df_for * normcdf(d1) / (S * sigma_tau_sqrt);
vega = S * sqrt(Te) * df_for * normcdf(d1);

end
