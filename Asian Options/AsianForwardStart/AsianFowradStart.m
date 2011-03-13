function P = AsianFowradStart(CP,S,Stf,wa,wf,m,Spg,df,r,b,sigS,sigX,rhoij,rhoi,ti,t,T,tf,lambda)
% -------------------------------------------------------------------------
% P = AsianFowradStart(CP,S,wa,wf,m,Sbasket,X,df1,r,b,sigS,sigX,rhoij,rhoi,ti,t,T,tf,lambda)
%
% Author: Michael Shou-Cheng Lee.
%
% This function calculates the price of a Asian Basket Fixed Strike
% option using RBC's method.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% S =   the array of current asset prices.
% Stf =  the array of asset prices at strike reset date.
% wa = the vector of normalised weights for asset.
% wf = the vector of normalised weights for fixings.
% m = the number of observed fixings.
% Spg = the matrix of obasket average at each observed fixing time.
% df = the discount factor from t to T.
% r =   the array of risk-free rates.
% b =   the array of cost of carries.
% sigS = i by j matrix of volatilities for the assets i at time tj.
% rhoij = the matrix of correlation for ln(Si) and ln(Sj).
% ti =  array of time to the ith fixing from
%       contract origination date.
% t =   the current time measured from contract origination date.
% T =   the original time to maturity.
% tf =  the time to set strike price.
% lambda = the array of spot strike ratio.
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
lambdasize = size(lambda);

length(S);
na;
bsize(1,1);
sigSsize(1,1);
rhoijsize(1,1);
rhoijsize(1,2);
lambdasize(1,1);

if (length(S)~=na || length(S)~=bsize(1,1) || length(S)~=sigSsize(1,1) || length(S)~=rhoijsize(1,1) || length(S)~=rhoijsize(1,2) || length(S)~=lambdasize(1,1))
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

if (t<tf)
    W1 = wa(:)'*lambda(:);
    wa = (wa(:).*lambda(:))/W1;
    K1 = 1/W1;
else
    W1 = 0;
    for i=1:length(wa)
        W1 = W1 + wa(i)*lambda(i)/Stf(i);
    end
    wa = (wa(:).*lambda(:))./(W1*Stf);
    K1 = 1/W1;
end

if (prod(size(Spg))==0)
    Stmbar = 0;
else
    Spgsize=size(Spg);
    sum = 0;
    for i = 1:na
        for j = 1:Spgsize(1,2)
            sum = sum + wa(i)*wf(j)*Spg(i,j);
        end
    end

    Stmbar = sum;
end

% Change the discount rate !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if (t>=ti(length(ti)))
    if (CP == 'c')
        P = df*(max(Stmbar-K1*df,0));
        %P = max(df*(Stmbar*exp(0.05665)*(T-t)-K),0);
    else
        P = df*(max(df*K1-Stmbar,0));
        %P = max(df*(K-Stmbar*exp(0.05665)*(T-t)),0);
    end

    return;
end


sum = 0;
for i= 1:na
    for j = m+1:nf
        bstar(i,j) = b(i,j)-rhoi(i)*sigS(i,j)*sigX(i);
        if(t<tf)
            F(i,j) = exp(bstar(i,j)*(ti(j)-tf));
        else
            F(i,j) = S(i)*exp(bstar(i,j)*(ti(j)-tf));
        end
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
                    exp(rhoij(i,k)*sigS(i,min(j,l))*sigS(k,min(j,l))*min(ti(j)-tf,ti(l)-tf));
            end
        end
    end
end
EM2 = sum;

v = sqrt(log(EM2)-2*log(EM1));

if t > ti(length(ti))
    if (CP == 'c')
        P = df*(max((Stmbar*exp(r(length(ti))*(T-t))-K1),0));
    else
        P = df*(max((K1-Stmbar*exp(r(length(ti))*(T-t))),0));
    end
else
    if (K1-Stmbar<0)
        S = Stmbar + EM1;
        if (CP == 'c')
            P = df*(S - K);
        else
            P = 0;
        end

    else
        d1 = (1/2*log(EM2)-log(K1-Stmbar)) / v;
        d2 = d1 - v;

        if (CP == 'c')
            P = df*W1*(EM1*normcdf(d1)-(K1-Stmbar)*normcdf(d2));
        else
            P = df*W1*(EM1*(normcdf(d1)-1)-(K1-Stmbar)*(normcdf(d2)-1));
        end

    end

end

end
