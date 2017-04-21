function V = GeskeV(L1,L2,sig,T)

% -------------------------------------------------------------------------
% V = GeskeV(L1,L2,sig,T)
% This function approximates the Bermudan swaption prices (Vectorized)
%
% L1 = vector of leg 1 values.
% L2 = vector of leg 2 values.
% sig = vector of volatilities.
% T = vector of tenor dates.
% -------------------------------------------------------------------------

d1 = (log(L1./L2) + 0.5.*sig.^2.*T)./(sig.*sqrt(T));
d2 = d1 - sig.*sqrt(T);

value = L1.*normcdf(d1) - L2.*normcdf(d2);

Vmax = max(value);
jmax = find(value == Vmax);

zmax = d2(jmax);

% delete max value
d2(jmax) = [];
value(jmax) = [];

V = Vmax + (1 - normcdf(zmax)) * sum(value.*normcdf(d2)) / sum(normcdf(d2));

end