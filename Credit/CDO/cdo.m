function V = cdo(m,data,l,u,s,d,ti)
% -------------------------------------------------------------------------
% E = cdo(m,data,l,u,s,d,ti)
% This function calculates the value of
% a particular CDO tranch.
%
% E = output price of tranch.
% m = tranch.
% data = matrix of notional, probability, a and number of assets.
% l = vector of lower bounds of the tranch.
% u = vector of upper bounds of the tranch.
% s = vector of cdo fixed rate.
% d = vector of discount factors.
% ti = vector of time intervals.
% -------------------------------------------------------------------------

llength = length(l);
ulength = length(u);
slength = length(s);
dlength = length(d);
n = length(ti);

if (llength~=ulength)
    fprintf('Number of tranches do not match.\n');
    return;
end
if (n~=slength || n~=dlength)
    fprintf('Number of tenor periods does not match.\n');
    return;
end
for i=2:llength
    if(l(i)~=u(i-1))
        fprintf('Tranch boundaries mismatch.\n');
        return;
    end
end
if(m<=0 || m>llength)
    fprintf('Tranch number incorrect\n.');
    return;
end

S = u - l;
dti = [ti(1);ti(2:n)-ti(1:n-1)];
uncondvalue = zeros(n,1);
for i=1:n
    uncondvalue(i) = uncondei(data(:,[1 i+1 7 8]),l(m),u(m));
end

summing1 = 0;
for i=1:n
    summing1 = summing1 + s(i)*dti(i)*d(i)*(S(m) - uncondvalue(i));
end

summing2 = d(1)*uncondvalue(1);
for i=2:n
    summing2 = summing2 + d(i)*(uncondvalue(i) - uncondvalue(i-1));
end
V = summing2 / summing1;

%V = summing1 - summing2;
