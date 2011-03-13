function R = correlation(data)
% -------------------------------------------------------------------------
% R = correlation(data)
% This function estimates the correlation matrix from forward rate data.
%
% R = output matrix of correlations.
% data = input matrix of forward rates.
% -------------------------------------------------------------------------

n = size(data,1);
m = size(data,2);
mu = zeros(n,1);
for i=1:n
    for k=1:m-1
        mu(i) = mu(i) + log(data(i,k+1)/data(i,k));
    end
    mu(i) = mu(i)/(m-1);
end
V = zeros(n,n);
for i=1:n
    for j=1:n
        for k=1:m-1
            V(i,j) = V(i,j) + (log(data(i,k+1)/data(i,k))-mu(i))*(log(data(j,k+1)/data(j,k))-mu(j));
        end
        V(i,j) = V(i,j) / (m-1);
    end
end
for i=1:n
    for j=1:n
        rho(i,j) = V(i,j) / (sqrt(V(i,i))*sqrt(V(j,j)));
    end
end
rhoinfinity = fsolve(@(rhoinf) solvingFunc(rhoinf,rho(1,n),rho(n-1,n),n), 0.5);
(rho(1,2)-rhoinfinity)/(rho(n-1,n)-rhoinfinity)
alpha = log((rho(1,2)-rhoinfinity)/(rho(n-1,n)-rhoinfinity))/(2-n);
beta = alpha - log((rho(1,2)-rhoinfinity)/(1-rhoinfinity));
for i=1:n
    for j=1:n
        rho(i,j) = rhoinfinity + (1-rhoinfinity)*exp(-abs(i-j)*(beta-alpha*(max(i,j)-1)));
    end
end
R = rho;
