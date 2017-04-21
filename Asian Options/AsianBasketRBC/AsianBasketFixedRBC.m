function P = AsianBasketFixedRBC(CP,S,K,wa,wf,m,Sbasket,df,r,b,sigS,rhoij,ti,t,T)
% -------------------------------------------------------------------------
% P = AsianBasketFixedRBC(CP,S,K,wa,wf,m,Sbasket,df,r,b,sigS,rhoij,ti,t,T)
%
% Author: Michael Shou-Cheng Lee.
%
% This function calculates the price of a Asian Basket Fixed Strike
% option using RBC's method.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% S =   the array of current asset prices.
% K =   the strike price.
% wa = the vector of normalised weights for asset.
% wf = the vector of normalised weights for fixings.
% m = the number of observed fixings.
% Sbasekt = the array of obasket average at each observed fixing time.
% df = the discount factor.
% r =   the array of risk-free rates.
% b =   the array of cost of carries.
% sigS = i by j matrix of volatilities for the assets i at time tj.
% rhoij = the matrix of correlation for ln(Si) and ln(Sj).
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract origination date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

if (CP ~= 'c' && CP ~= 'p')
    fprintf('Call/Put CP must be ''c'' or ''p''.\n');
    return;
end

na = size(wa);
na = na(1,1);
nf = size(wf);
nf = nf(1,1);

rhoijsize = size(rhoij);
rsize = size(r);
bsize = size(b);
sigSsize = size(sigS);

if (length(S)~=na || length(S)~=bsize(1,1) || length(S)~=sigSsize(1,1) || length(S)~=rhoijsize(1,1) || length(S)~=rhoijsize(1,2))
    fprintf('Array of inputs do not match.\n');
    return;
end

if (nf~=rsize(1,2) || nf~=bsize(1,2) || nf~=length(ti))
    fprintf('Array of inputs do not match.\n');
    return;
end

%sizeSpg = size(Spg);
%if (t==ti(sizeSpg(1,2)) && norm(S-Spg(:,sizeSpg(1,2)))>eps*prod(sizeSpg))
%    fprintf('Current asset price does not match the observed fixing.\n');
%    return;
%end
if (T<ti(nf))
    fprintf('Last fixing cannot be after the maturity date.\n');
    return;
end
if (t > T)
    fprintf('Option is already expired.\n');
    return;
end

%m = size(Spg);
%m = m(1,2);

sum = 0;
for i = 1:m
        sum = sum + wf(i)*Sbasket(i);
end
Stmbar = sum;

if (t>=ti(length(ti)))
    if (CP == 'c')
        P = max(Stmbar-K*df,0);
        %P = max(df*(Stmbar*exp(0.05665)*(T-t)-K),0);
    else
        P = max(df*K-Stmbar,0);
        %P = max(df*(K-Stmbar*exp(0.05665)*(T-t)),0);
    end
    
    return;
end

sum = 0;
for i= 1:na
    for j = m+1:nf
        bstar(i,j) = b(i,j);
        F(i,j) = S(i)*exp(bstar(i,j)*(ti(j)-t));
        sum = sum + wa(i)*wf(j)*F(i,j);
    end
end
EM1 = sum;

sum = 0;
for i = 1:na
    for j = m+1:nf
        for k = 1:na
            for l = m+1:nf
                sum = sum + wa(i)*wf(j)*wa(k)*wf(l)*F(i,j)*F(k,l)* ... 
                    exp(rhoij(i,k)*sigS(i,min(j,l))*sigS(k,min(j,l))*min(ti(j)-t,ti(l)-t));
            end
        end
    end
end
EM2 = sum;

v = sqrt(log(EM2)-2*log(EM1));

if (t > ti(length(ti)))
    if (CP == 'c')
        P = max(df*(Stmbar*exp(r(length(ti))*(T-t))-K),0);
    else
        P = max(df*(K-Stmbar*exp(r(length(ti))*(T-t))),0);
    end
else
    if (K-Stmbar<0)
        S = Stmbar + EM1;
        if (CP == 'c')
            P = df*(S - K);
        else
            P = 0;
        end

    else
        d1 = (1/2*log(EM2)-log(K-Stmbar)) / v;
        d2 = d1 - v;

        if (CP == 'c')
            P = df*(EM1*normcdf(d1)-(K-Stmbar)*normcdf(d2));
        else
            P = df*(EM1*(normcdf(d1)-1)-(K-Stmbar)*(normcdf(d2)-1));
        end

    end

end

end
