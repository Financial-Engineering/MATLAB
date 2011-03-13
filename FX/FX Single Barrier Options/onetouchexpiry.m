function p = onetouchexpiry(S,H,b,r,sigma,T,K,inCCY1)

    if S < H
        eta = -1;
    else
        eta = 1;
    end

    sigma_T_sqrt = sigma * sqrt(T);
    mu1 = b + 0.5 * sigma * sigma;
    mu2 = b - 0.5 * sigma * sigma;
    beta1 = 2 * mu1 / (sigma * sigma);
    beta2 = 2 * mu2 / (sigma * sigma);
    x1 = (log(S/H) + mu1*T)/sigma_T_sqrt;
    x2 = x1 - sigma_T_sqrt;
    y1 = (log(H/S) + mu1*T)/sigma_T_sqrt;
    y2 = y1 - sigma_T_sqrt;
    
    if (~inCCY1)
        p = S * exp((b-r)*T) * (normcdf(-eta*x1) + (H/S)^(beta1) * normcdf(eta*y1));
    else    
        p = K * exp(-r*T) * (normcdf(-eta*x2) + (H/S)^(beta2) * normcdf(eta*y2));
    end
end