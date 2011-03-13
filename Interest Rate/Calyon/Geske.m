function V = Geske(L1,L2,sig,T)

% -------------------------------------------------------------------------
% V = Geske(L1,L2,sig,T)
% This function approximates the Bermudan swaption prices.
%
% L1 = vector of leg 1 values.
% L2 = vector of leg 2 values.
% sig = vector of volatilities.
% T = vector of tenor dates.
% -------------------------------------------------------------------------

n = length(T);

for i = 1:n
    d1(i) = (log(L1(i)/L2(i))+1/2*sig(i)^2*T(i)) / (sig(i)*sqrt(T(i)));
    d2(i) = d1(i) - sig(i)*sqrt(T(i));
end

for i = 1:n
    value(i) = L1(i)*cnorm(d1(i))-L2(i)*cnorm(d2(i));
end

Vmax = max(value);
jmax = find(value==Vmax);

sum1 = 0;
sum2 = 0;
for i=1:n
    sum1 = sum1 + value(i)*cnorm(d2(i));
    sum2 = sum2 + cnorm(d2(i));
end
sum1 = sum1 - value(jmax)*cnorm(d2(jmax));
sum2 = sum2 - cnorm(d2(jmax));

V = Vmax + (1 - cnorm(d2(jmax)))*sum1/sum2;
end
