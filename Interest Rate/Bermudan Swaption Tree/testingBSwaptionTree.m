% This program tests the BSwaptionTree function.

beta = 1;
N = 100;
K = 0.062;
s = 0;
dfti = [exp(-0.06*5);exp(-0.06*5.5);exp(-0.06*6);exp(-0.06*6.5);exp(-0.06*7);exp(-0.06*7.5);exp(-0.06*8)];
sigb = [0.2 0.2 0.2 0.2 0.2 0.2];
%sigb = 0.2;
tib = [5 5.5 6 6.5 7 7.5];
%tib = 5;
ti = linspace(5,8,7);
M = 1000;
dt = tib(length(tib))/M;
dfn = zeros(M,1);
for i=1:M
    dfn(i) = exp(-0.06*i*dt);
end
BSwaptionTree(beta,N,K,s,dfn,dfti,sigb,tib,ti,M)
sigb = 0.2;
tib = 5;
ti = linspace(5,8,7);
M = 1000;
dt = tib(length(tib))/M;
dfn = zeros(M,1);
for i=1:M
    dfn(i) = exp(-0.06*i*dt);
end
BSwaptionTree(beta,N,K,s,dfn,dfti,sigb,tib,ti,M)
