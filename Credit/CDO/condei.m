function E = condei(data,l,u,M)
% -------------------------------------------------------------------------
% E = condei(data,l,u,M)
% This function calculates the conditional expectation 
% of a particular CDO tranch value for period i.
%
% E = output price of tranch.
% data = matrix of notional, probability, a and number of assets.
% l = lower bound of the tranch.
% u = upper bound of the tranch.
% M = correlation driver value.
% -------------------------------------------------------------------------

Nl = min(data(:,1));
Nu = max(data(:,1));

p = cnorm((norminv(data(:,2))-data(:,3)*M)./sqrt(1-data(:,3).^2));
lambda = sum(p.*data(:,4));
S = u - l;

pnew = zeros(sum(data(:,1).*data(:,4)),1);
for i=1:length(pnew)
    index = find(data(:,1)==i);
    if(length(index>0))
        pnew(i) = sum(p(index).*data(index,4));
    end
end
f1 = pnew/lambda;

if(mod(l,Nl)==0)
    ml = l/Nl;
else
    ml = floor(l/Nl);
end

sum1 = 0;
for m=1:ml
    fm = convo(m,f1);
    sumconv1 = 0;
    for j=m*Nl:l
      sumconv1 = sumconv1 + fm(j-m+1);
    end
    sum1 = sum1 + lambda^m/factorial(m)*sumconv1;
end

if(mod(l,Nl)==0)
    ml = l/Nl + 1;
else
    ml = ceil(l/Nl);
end
if(mod(u,Nl)==0)
    mu = u/Nl + 1;
else
    mu = floor(u/Nl);
end

sum2 = 0;
for m=ml:mu
    fm = convo(m,f1);
    sumconv2 = 0;
    for j=m*Nl:ceil(u)-1 % be careful with the boundaries.
        sumconv2 = sumconv2 + (u-j)*fm(j-m+1);
    end
    sum2 = sum2 + lambda^m/factorial(m)*sumconv2;
end

E = S*(1-exp(-lambda)) - exp(-lambda)*(S*sum1+sum2);
