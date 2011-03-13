% This program tests the Longstaff-Schwartz algorithm.
X = [1.09 1.08 1.34;1.16 1.26 1.54;1.22 1.07 1.03;0.93 0.97 0.92;1.11 1.56 1.52;0.76 0.77 0.90;0.92 0.84 1.01;0.88 1.22 1.34];
U = [exp(0.06*1)*ones(8,1) exp(0.06*2)*ones(8,1) exp(0.06*3)*ones(8,1)];
U0 = ones(8,1);
E = max(1.10-X,0);
tk = [1;2;3];
te = [1 2 3];
LS(X,U,U0,E,tk,te)
