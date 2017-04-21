function [sig rho] = fittingSABR(data,alpha,beta)
%--------------------------------------------------------------------------
% [sig rho] = fittingSABR(data,alpah,beta)
% This function fits the sig and rho parameter of SABR model.
%
% [sig rho] = output sig and rho parameters.
% data = [K f T vol].
% alpah = obtained from ATMvol.
% beta = scale parameter.
% -------------------------------------------------------------------------

    [sig rho] = lsqnonlin(@(z0) sse(z0,data,alpha,beta),[0.5 -0.5],[0 -1], ...
        [5,1], optimset('Display','Iter','MaxIter',30000,'MaxFunEvals',500000,'TolFun',1e-4));
end