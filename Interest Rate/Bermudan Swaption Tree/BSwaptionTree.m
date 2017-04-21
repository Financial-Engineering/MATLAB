function P = BSwaptionTree(beta,N,K,s,dfn,dfti,sigb,tib,ti,M)
% -------------------------------------------------------------------------
% P = BSwaptionTree(beta,N,K,s,dfn,dfti,sigb,tib,ti,M)
% This function calculates the Bermudan swaption price using binomial tree
% method.
%
% P = output price.
% beta = 1 if receving floating and paying fixed; -1 if paying floating and
% receving fixed.
% N = notional amount.
% K = strike price.
% s = spread.
% dfn = vector of discount factors from node dates to the valuation date.
% dfti = vector of discount factors from node dates to the valuation date.
% sigb = vector of volatilities.
% tib = vector of exercise dates.
% ti = vector of tenor dates.
% M = number of tree steps.
% -------------------------------------------------------------------------

dfn = dfn(:);
dfti = dfti(:);
sigb = sigb(:);
tib = tib(:);
ti = ti(:);
ndfn = length(dfn);
ndfti = length(dfti);
nsigb = length(sigb);
ntib = length(tib);
nti = length(ti);
% -------------------------------------------------------------------------
% This section checks if the inputs are valid.
if (beta~=1 && beata~=-1)
    fprintf('beta must be 1 or -1.\n');
    return;
end
if (ndfn~=M)
    fprintf('Node date dimension does not match.\n');
    return;
end
if (ndfti~=nti)
    fprintf('Tenor date dimension does not match.\n');
    return;
end
if (nsigb~=ntib)
    fprintf('Exercise date dimension does not match.\n');
    return;
end
if (tib(ntib)>=ti(nti))
    fprintf('Last exercise date cannot be after last swap payment date.\n');
    return;
end
if (ti(1)<0)
    fprintf('Swap starting date cannot be before valuation date.\n');
    return;
end
if (tib(1)<ti(1))
    fprintf('There is no point to have exercise date before the swap starts.\n');
    return;
end
% -------------------------------------------------------------------------
tau = [ti(1);ti(2:nti)-ti(1:nti-1)];
dt = tib(ntib) / M;
tibindex = round(tib/dt);
dftib = dfn(tibindex);
Atib = zeros(ntib,1); % This is the numeraire for swap measure.
for i=1:ntib
    n = find([0;ti(2:nti)]>tib(i), 1 ); % We put 0 for first element becasue the first payment is after the first tenor date.
    for j=n:nti
        Atib(i) = Atib(i) + tau(j)*dfti(j);
    end
end
A = Atib./dftib;
Z = zeros(M,M+1);
for i=1:M
    for j=1:i+1
        Z(i,j) = (2*(j-1)-i)*sqrt(dt);
    end
end
F = zeros(nti,1);
for i=2:nti % Starting from 2 because we do not need the forward rate to the swap starting date.
    F(i) = (dfti(n-1)/dfti(n)-1)/tau(n);
end
FS = zeros(ntib,1);
counter = 1;
for i=1:ntib
    for j=find([0;ti(2:nti)]>tib(counter))' % Summing the rest of cash flows after the exercise date.
        FS(i) = FS(i) + ((F(j)+s)*tau(j)*dfti(j))/Atib(i);
    end
    counter = counter + 1;
end
S = zeros(M,M+1);
counter = 1;
for i=tibindex'
    for j=1:i+1
        S(i,j) = FS(counter)*exp(-0.5*sigb(counter)^2*i*dt+sigb(counter)*Z(i,j));
    end
    counter = counter + 1;
end
V = zeros(M,M+1);
for j=1:M+1
    V(M,j) = A(ntib)*max(beta*(S(M,j)-K),0);
end
counter = ntib-1;
for i=M-1:-1:1
    for j=1:i+1
        V(i,j) = dfn(i+1)/dfn(i)*1/2*(V(i+1,j)+V(i+1,j+1));
        if (~isempty(find(i==tibindex, 1)))
            V(i,j) = max(A(counter)*beta*max(S(i,j)-K,0),V(i,j));
        end
    end
    if(find(i==tibindex)~=0)
        counter = counter - 1;
    end
end

P = N*dfn(1)*1/2*(V(1,1)+V(1,2));
