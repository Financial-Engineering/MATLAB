function [EM1,EM2] = LevyVariableMoment(S,alp,Spg,b,sig,n,ti,t)
% -------------------------------------------------------------------------
% function [EM1,EM2] = LevyMomentMatching(S,b,n,t0,tm,tn,t)
% This function calculates the two moments using
% Levy model.
%
% S =   the current asset price.
% alp = the array normalised weights.
% Spg = the array of observed fixings.
% b =   the cost of carry.
% sig = the volatility.
% n =   the total number of fixings.
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract initiation date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

m = length(Spg);
alpmlater = alp(m+1:n);
tafter = ti(m+1:n);

sum1 = S*alpmlater'*exp(b*(tafter-t));

sum2 = 0;
for i = m+1:n
    for j = m+1:n
        sum2 = sum2 + alp(i)*alp(j) ... 
            *exp(b*(ti(i)+ti(j)-2*t)+sig^2*min(ti(i)-t,ti(j)-t));
    end
end

sum2 = S^2*sum2;

EM1 = sum1;
EM2 = sum2;

end


