% Inputs:-
% vol_m = a set of market implied vols (varying maturities and moneyness (strikes/spot))
% init_min_parms = initial guess on alpha and rho (each is a scaler)
% model_parms (K, beta, T, F0, sigma0) = model inputs (each is a vector),
% with each element in the vector is for each market implied vol
function[nu, rho] = calibrateSABR(vol_m, init_min_parms, model_parms)
    [min_parms, fval] = fminsearch(@(min_parms) obj_fun(vol_m, min_parms, model_parms, @sabrvol_new_wrapper), init_min_parms, optimset('Display','Iter','MaxIter',30000,'MaxFunEvals',500000,'TolFun',1e-4));
    nu = min_parms(1);
    rho = min_parms(2);
end