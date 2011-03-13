function C = corr(data)
% -------------------------------------------------------------------------
% C = corr(data)
% This program calculates the correlation coefficient.
%
% C = output correlation matrix.
% data = input data.
% -------------------------------------------------------------------------

nc = size(data,2);
average = zeros(nc,1);
sig = zeros(nc,1);
n = zeros(nc,1);
for i = 1:nc
    n(i) = length(find(data(:,i)~=exp(1)));
end
for i = 1:nc
    average(i) = mean(data(1:n(i),i));
    sig(i) = std(data(1:n(i),i));
end
cij = zeros(nc,nc);
for i=1:nc
    for j=i:nc
        if i==j
            cij(i,j) = 1;
        else
            summing = 0;
            for m=1:min(n(i),n(j))
                summing = summing + (data(m,i)-average(i))*(data(m,j)-average(j));
            end
            cij(i,j) = (summing/(min(n(i),n(j))-1))/(sig(i)*sig(j));
            cij(j,i) = cij(i,j);
        end
    end
end

C = cij;
