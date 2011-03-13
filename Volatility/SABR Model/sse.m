function E = sse(z0,data,alpha,beta)
% -------------------------------------------------------------------------
% E = sse(z0,data,alpha,beta)
% This function calculates the sum of squared errors.
%
% E = output sum of squared errors.
% z0 = parameters of sig and rho.
% data = [K f T vol].
% alpah = obtained from ATMvol.
% beta = scale parameter.
% -------------------------------------------------------------------------
    sabrvol(K,f,alpha,beta,sig,rho,T)
    n = size(data,1);

    summing = 0;
    for i = 1:n
        summing = summing + (sabrvol(data(i,1),data(i,2),alpha,beta,z0(1),z0(2),data(i,3)) - data(i,4))^2;
    end
end
