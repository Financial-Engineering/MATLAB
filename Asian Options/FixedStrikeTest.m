% This program tests the Fixed Strike Asian Options.

% Test for plain-vanilla case, i.e. valutation time is on the
% first fixing date.

S = 50
K = 50
alp=[0.10;0.15;0.20;0.25;0.30]
Spg = 50
r = 0.001*ones(5,1)
b = 0.001*ones(5,1)
sig = 0.01*ones(5,1)
t = 0
T = 1
FixedStrike('c',S,K,alp,Spg,df,r,b,sig,ti,t,T)
FixedStrike('c',S,0.000000001,alp,Spg,df,r,b,sig,ti,t,T)
fprintf('If the price is correct, it should be less than and close to 50.\n');
