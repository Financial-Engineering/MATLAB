function [EM1,EM2] = MomentMatching(S,alp,Spg,b,sig,ti,t)
% -------------------------------------------------------------------------
% function [EM1,EM2] = MomentMatching(S,alp,Spg,b,sig,ti,t)
% This function calculates the two moments using Levy's method.
%
% Author: Michael Shou-Cheng Lee.
%
% S =   the current asset price.
% alp = the array normalised weights.
% Spg = the array of observed fixings.
% b =   the array of cost of carries.
% sig = the array of volatilities.
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract origination date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

n = length(alp);
m = length(Spg);

sum1 = 0;
for i = m+1:n
    F(i) = S*exp(b(i)*(ti(i)-t));
    sum1 = sum1 + alp(i)*F(i);
end

sum2 = 0;
for i = m+1:n
    for j = m+1:n
        F(i) = S*exp(b(i)*(ti(i)-t));
        F(j) = S*exp(b(j)*(ti(j)-t));
        
        if(ti(i)<=ti(j))
            sigmin = sig(i);
        else
            sigmin = sig(j);
        end
        
        sum2 = sum2 + alp(i)*alp(j)*F(i)*F(j)* ... 
            exp(sigmin^2*min(ti(i)-t,ti(j)-t));
     
    end
end

EM1 = sum1;
EM2 = sum2;

end
