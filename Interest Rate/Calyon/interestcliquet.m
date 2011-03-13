function P = interestcliquet(L,K,sigL,df,TT1)
% -------------------------------------------------------------------------
% P = interestcliquet(L,sigL,df,TT1)
% This function calculates the price of an interest rate cliquet.
%
% P = output price.
% L = vector of forward LIBOR rate.
% K = the first strike price.
% sigL = vector of volatility.
% df = vector of discount factors.
% TT1 = vector of tenor dates.
% -------------------------------------------------------------------------

L = L(:);
sigL = sigL(:);
df = df(:);
TT1 = TT1(:);

inputvectorsize = [length(L);length(sigL);length(df);length(TT1)];
if (norm(inputvectorsize-length(L)*ones(4,1),inf)~=0)
    fprintf('Size of input is wrong.\n');
    return;
end

n = length(L);
tau = TT1(2:n)-TT1(1:n-1);
tau = [TT1(1);tau];
p1 = caplet(L(1),K,sigL(1),df(1),TT1(1));
pn = caplet(L(2:n),L(1:n-1),sigL(2:n),df(2:n),TT1(2:n));
pvector = [p1;pn];
pvector = tau.*pvector;

P = sum(pvector);
