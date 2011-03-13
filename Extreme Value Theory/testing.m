% This program tests the extreme value theorem codes.

clear;
load lossdata.txt;
x = lossdata;
ita = 0.2;
beta = 0.01;
u = 0.02;
sum(logfunction(x,ita,beta,u))

p = estimate(x,u)

q = 0.99;
ita = p(1);
beta = p(2);
nu = 28;
n = 2256;
value(q,ita,beta,u,nu,n)
