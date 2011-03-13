function C = caplet(L,K,sigL,df,T)
% -------------------------------------------------------------------------
% C = caplet(L,K,sigL,df,T)
% This function computes the price of the caplet.
%
% C = output price.
% L = current forward LIBOR rate.
% K = strike price.
% sigL = volatility.
% df = discount factor.
% T = time to maturity.
% -------------------------------------------------------------------------
L = L(:);
K = K(:);
sigL = sigL(:);
df = df(:);
T = T(:);

inputvectorsize = [length(L);length(K);length(sigL);length(df);length(T)];
if (norm(inputvectorsize-length(L)*ones(5,1),inf)~=0)
    fprintf('Size of input is wrong.\n');
    return;
end
d1 = (log(L./K))./sigL+1/2*sigL;
d2 = d1 - sigL;

C = df.*(L.*cnorm(d1) - K.*cnorm(d2));
