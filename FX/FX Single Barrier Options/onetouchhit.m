function p = onetouchhit(S,H,b,r,sigma,Te,Td,K,inCCY1)

    if S < H
        eta = -1;
    else
        eta = 1;
    end

    sigma_T_sqrt = sigma * sqrt(Te);
    mu = (b - 0.5 * sigma * sigma)/(sigma * sigma);
   
    lambda = sqrt((mu * mu) + 2.0 * r / (sigma * sigma));
    
    z = log(H / S) / sigma_T_sqrt + lambda * sigma_T_sqrt;
    
    p = K * ((H/S)^(mu+lambda) * normcdf(eta*z) + (H/S)^(mu-lambda) * normcdf(eta*(z-2*lambda*sigma_T_sqrt)));
end
