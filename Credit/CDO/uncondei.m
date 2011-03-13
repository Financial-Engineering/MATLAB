function E = uncondei(data,l,u)
% -------------------------------------------------------------------------
% E = uncondei(data,l,u)
% This function calculates the unconditional expectation of
% a particular CDO tranch value for period i.
%
% E = output price of tranch.
% data = matrix of notional, probability, a and number of assets.
% l = lower bound of the tranch.
% u = upper bound of the tranch.
% -------------------------------------------------------------------------

[x,w] = gauleg(10,-5,5);

summing = 0;
for i=1:10
    summing = summing + condei(data,l,u,x(i))*w(i)*pdf(x(i));
end

E = summing;
