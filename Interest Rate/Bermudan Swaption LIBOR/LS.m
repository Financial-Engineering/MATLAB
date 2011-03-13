function V = LS(X,U,U0,E,tk,te)
% --------------------------------------------------------------
% V = LS(X,U,U0,tk,te)
% This function calculates the optimised value using Longstaff and Schwartz
% algorithm.
%
% V = output value.
% X = simulated payoff matrix.
% U = simulated numeraire matrix.
% U0 = initial numeraire vector.
% E = simulated exercise matrix.
% tk = vector of tenor dates.
% te = vector of exercise dates.
% --------------------------------------------------------------
    tk = tk(:);
    te = te(:);
    n1 = size(X,2);
    n2 = size(X,1);
    n3 = size(U,2);
    n4 = size(U,1);
    n5 = length(tk);
    n6 = size(E,2);
    n7 = size(E,1);
    n8 = length(U0);
    
    if(n1~=n3 || n1~=n5 || n1~=n6)
        fprintf('Tenor dimenstion does not match.\n');
        return;
    end

    if(n2~=n4 || n2~=n7 || n2~=n8)
        fprintf('Path dimension does not match.\n');
        return;
    end
    
    tauk = [tk(1);tk(2:n5)-tk(1:n5-1)];
    CC = zeros(n2,n1);
    EF = zeros(n2,n1);
    EF(E(:,n1)>0,n1) = 1;
    CC(:,n1) = E(:,n1);
    
    for k=n1:-1:2
        RY = U(E(:,k-1)>0,k).*CC(E(:,k-1)>0,k);
        RX = [ones(length(find(E(:,k-1)>0)),1) X(E(:,k-1)>0,k-1) X(E(:,k-1)>0,k-1).^2];
        lambda = RX \ RY;
        for j=find(E(:,k-1)>0)'
            EY = lambda(1) + lambda(2)*X(j,k-1) + lambda(3)*X(j,k-1)^2;
            if (E(j,k-1)>EY && ~isempty(find(tk(k-1)==te, 1)))
                CC(j,k-1) = E(j,k-1);
                EF(j,k-1) = 1;
                EF(j,k:n1) = 0;
            else
                CC(j,k-1) = U(j,k) * CC(j,k);
            end
        end
    end
    
    for j=1:n5
        if(isempty(find(tk(j)==te, 1)))
            EF(:,j) = zeros(n2,1);
        end
    end
    
    dvalue = zeros(n2,n1);
    for i=1:n2
        for j=1:n1
            if(EF(i,j)==1)
                dvalue(i,j) = E(i,j)*U(i,j)*U0(i);
            end
        end
    end

    V = sum(sum(dvalue)) / n8;
end
