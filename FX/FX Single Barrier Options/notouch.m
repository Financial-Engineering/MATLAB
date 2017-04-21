function p = notouch(S,H,b,r,sigma,Te,Td,K,inCCY1)

    if S < H
        eta = -1;
    else
        eta = 1;
    end

    sigma_T_sqrt = sigma * sqrt(Te);
    mu = b/(sigma*sigma)-0.5;
    x2 = log(S/H)/sigma_T_sqrt + (mu+1)*sigma_T_sqrt;
    x1 = x2 - sigma_T_sqrt;
    y2 = log(H/S)/sigma_T_sqrt + (mu+1)*sigma_T_sqrt;
    y1 = y2 - sigma_T_sqrt;
    
    if (inCCY1)
       % Cash B2-B4
       p = K * exp(-r*Td) * (normcdf(eta*x1) - (H/S)^(2*mu) * normcdf(eta*y1));
    else
       % Asset A2-A4
       p = S * exp((b-r)*Td) * (normcdf(eta*x2) - (H/S)^(2*(mu+1)) * normcdf(eta*y2));
    end
end
