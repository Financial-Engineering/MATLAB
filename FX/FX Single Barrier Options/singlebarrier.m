function p = singlebarrier(in,cp,S,X,H,r,b,sigma,Te,Td,K,atExp,inCCY1)

    sigma_T_sqrt = sigma * sqrt(Te);

    phi = cp;
    
    call = 0;
    if cp == 1
        call = 1;
    end
    
    if S < H
        eta = -1;
    else
        eta = 1;
    end

    mu = (b - (sigma * sigma / 2))/(sigma * sigma);
    lambda = sqrt(mu * mu + 2 * r/(sigma * sigma));

    x1 = log(S / X) / sigma_T_sqrt + (1 + mu) * sigma_T_sqrt;
    x2 = log(S / H) / sigma_T_sqrt + (1 + mu) * sigma_T_sqrt;

    y1 = log(H * H /(S * X)) / sigma_T_sqrt + (1 + mu) * sigma_T_sqrt;
    y2 = log(H / S) / sigma_T_sqrt + (1 + mu) * sigma_T_sqrt;

    df1 = phi*S*exp((b-r)*Td);
    df2 = phi*X*exp(-r*Td);

    A =	(df1 * normcdf(phi*x1) - df2 * normcdf(phi*(x1-sigma_T_sqrt)));
    B = (df1 * normcdf(phi*x2) - df2 * normcdf(phi*(x2-sigma_T_sqrt)));
    C =	(df1 * (H/S)^(2*(mu+1)) * normcdf(eta*y1) - df2 * (H/S)^(2*mu) * normcdf(eta*y1 - eta*sigma_T_sqrt));
    D =	(df1 * (H/S)^(2*(mu+1)) * normcdf(eta*y2) - df2 * (H/S)^(2*mu) * normcdf(eta*y2 - eta*sigma_T_sqrt));
    
    % Rebates defined as digitals
    E = notouch(S,H,b,r,sigma,Te,Td,K,inCCY1);
    F = onetouchhit(S,H,b,r,sigma,Te,Td,K,inCCY1);
    G = onetouchexpiry(S,H,b,r,sigma,Te,K,inCCY1);
       
    p = 0.0;

    if (in)
        % Down-in Call S > H, Up-in Put S < H
        if (S >= H && X > H && call) || (S < H && X <= H && ~call)
            p = C + E;
        end        
        if (S >= H && X <= H && call) || (S < H && X > H && ~call)
            p = A - B + D + E;
        end
        
        % Up-in Call S < H, Down-in Put S > H
        if (S < H && X > H && call) || (S >= H && X <= H && ~call)
            p = A + E;
        end
        if (S < H && X <= H && call) || (S >= H && X > H && ~call)
            p = B - C + D + E;
        end
    else
        % If knock-out rebate at exp then use G term
        if (atExp)
            F = G;
        end

        if (S >= H && X > H && call) || (S < H && X <= H && ~call)
            p = A - C + F;
        end
        if (S >= H && X <= H && call) || (S < H && X > H && ~call)
            p = B - D + F;
        end
        
        if (S < H && X > H && call) || (S >= H && X <= H && ~call)
            p = F;
        end
        if (S < H && X <= H && call) || (S >= H && X > H && ~call)
            p = A - B + C - D + F;
        end        
    end    
end

