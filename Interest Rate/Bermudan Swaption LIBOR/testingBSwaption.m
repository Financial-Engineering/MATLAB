% This program tests the function BSwaption.

points = 'q';
f = [0.050114;0.055973;0.058387];
K = 0.05;
V = [0.18000000000000 0 0;0.1540 0.2050 0;0.1270 0.1570 0.2340];
ic;
rho = rho(1:3,1:3);
C = zeros(3,3);
for i=1:3
    for j=1:3
        C(i,j) = rho(i,j)*V(i)*V(j);
    end
end
F = 3;
ti = linspace(1,3,3);
%te = 1;
te = ti(1:2);
%te = ti(length(ti));
t = 0;
np = 5000;
N = 1000000;
S = 0.05;
BSwaption(points,S,f,K,C,F,ti,te,t,np)
swaptionBlack(S,f,K,C,ti,t)
