% Inputs :- (all vectors are of same size)
% K = Strike (vector)
% nu = vol of vol (scaler)
% beta = scale parameter (vector)
% rho = correlation between forward rate and vol (scaler)
% T = time to maturity of the option (vector)
% F0 = current forward rate observed in the market (vector)
% sigma0 = implied vol for at-the-money (ATM) option (vector)
function [sigma_black] = sabrvol(K, nu, beta, rho, T, F0, sigma0)
    %F_mid = (F0 + K) / 2;
    %Z = nu ./ (sigma0.*(1-beta)) .* (F0.^(1-beta) - K.^(1-beta));
    %gamma1 = beta ./ F_mid;
    %gamma2 = -beta .* (1-beta) ./ (F_mid.^2);
    %D_Z = log((sqrt(1-2.*rho.*Z+(Z.^2)) + Z - rho)./(1-rho));
    %term = sigma0 .* (F_mid.^beta) / nu;
    %sigma_black = nu .* log(F0./K) ./ D_Z .* (1 + ((2*gamma2-(gamma1.^2)+1./(F_mid.^2))/24 .* (term.^2) + rho.*gamma1/4 .* term + (2-3*(rho.^2))/24) .* T .* (nu.^2));    
   
%%%%%%%%%%%    
    z = nu./sigma0.*(F0.*K).^((1-beta)/2).*log(F0./K);
    x = log((sqrt(1-2*rho*z+z.^2)+z-rho)./(1-rho));

    factor1 = (F0.*K).^((1-beta)/2).*(1+(1-beta).^2/24.*(log(F0./K)).^2+(1-beta).^4/1920.*(log(F0./K)).^4);
    factor2 = ((1-beta).^2/24.*sigma0.^2/((F0.*K).^(1-beta))+1/4*rho*beta.*nu.*sigma0/((F0.*K).^((1-beta)./2))+(2-3*rho^2)/24*nu^2).*T;

    n = length(K); % num of input market vols for calibration
    i = (K~=F0);
    not_atm = findIndexOfValue(1, i, 'all');    
    atm = setdiff(1:n,not_atm);    
    sigma_black(not_atm) = sigma0(not_atm)./factor1(not_atm).*z(not_atm)./x(not_atm).*(1+factor2(not_atm));
    sigma_black(atm) = sigma0(atm)./F0(atm).^(1-beta(atm)).*(1+((1-beta(atm)).^2/24.*sigma0(atm).^2./F0(atm).^(2-2*beta(atm))+1/4*rho*beta(atm).*sigma0(atm)*nu./F0(atm).^(1-beta(atm))+(2-3*rho^2)/24*nu^2).*T(atm));        
    
%%%%%%%%%%%
    %n = length(K);
    %for i=1:n
    %    z = nu/sigma0(i)*(F0(i)*K(i))^((1-beta(i))/2)*log(F0(i)/K(i));
    %    x = log((sqrt(1-2*rho*z*z^2)+z-rho)/(1-rho));

    %    factor1 = (F0(i)*K(i))^((1-beta(i))/2)*(1+(1-beta(i))^2/24*(log(F0(i)/K(i)))^2+(1-beta(i))^4/1920*(log(F0(i)/K(i)))^4);
    %    factor2 = ((1-beta(i))^2/24*sigma0(i)^2/((F0(i)*K(i))^(1-beta(i)))+1/4*rho*beta(i)*nu*sigma0(i)/((F0(i)*K(i))^((1-beta(i))/2))+(2-3*rho^2)/24*nu^2)*T(i);

    %    if K~=f
    %        sigma_black(i) = sigma0(i)/factor1*z/x*(1+factor2);
    %    else
    %        sigma_black(i) = sigma0(i)/F0(i)^(1-beta(i))*(1+((1-beta(i))^2/24*sigma0(i)^2/F0(i)^(2-2*beta(i))+1/4*rho*beta(i)*sigma0(i)*nu/F0(i)^(1-beta(i))+(2-3*rho^2)/24*nu^2)*T(i));
    %    end
    %end
end