% This program validates the simulation.

load rate0ran1.mat;
load rate0ran2.mat;
load rate1ran1.mat;
load rate1ran2.mat;
load rate2ran1.mat;
load rate2ran2.mat;
load rate0sim1.txt;
load rate0sim2.txt;
load rate1sim1.txt;
load rate1sim2.txt;
load rate2sim1.txt;
load rate2sim2.txt;
load rate0historical.txt;
load rate1historical.txt;
load rate2historical.txt;
load historical.txt;
load crate0historical.txt;
load randall.txt;
load crate0sim1.txt;
load crate0sim2.txt;
load crate1sim1.txt;
load crate1sim2.txt;
load crate2sim1.txt;
load crate2sim2.txt;
load originalrate0.txt;
load originalrate1.txt;
load originalrate2.txt;
load correcthistorical.txt;
load correctrandall.txt;
load correctrate0sim1.txt;
load correctrate0sim2.txt;
load correctrate1sim1.txt;
load correctrate1sim2.txt;
load correctrate2sim1.txt;
load correctrate2sim2.txt;

% -------- Uncorrelated Rates --------
% -------- Lognormal Model --------
fprintf('-------- Uncorrelated Rates --------\n');
fprintf('-------- Lognomal Model --------\n');
P = estimate1(flipud(rate0historical),252);
mu = P(1);
vol = P(2);
fprintf('Razor mu = 0.032946408.\n');
fprintf('Matlab mu = %.9f.\n', mu);
fprintf('Razor vol = 0.088350022.\n');
fprintf('Matlab vol = %.9f.\n', vol);

n1 = length(rate0ran1);
sim1 = simulatelognormal(rate0ran1,ones(n1,1),mu,vol,1/365);
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(rate0sim1-sim1,2));
sim2 = simulatelognormal(rate0ran2,sim1,mu,vol,1/365);
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(rate0sim2-sim2,2));

% -------- Normal Mean Reversion Model --------
fprintf('-------- Normal Mean Reversion Model --------\n');
P = estimatenormalrevert(flipud(rate1historical), 252);
drift = P(1);
meanreversion = P(2);
vol = P(3);
fprintf('Razor drift = -0.000264589.\n');
fprintf('Matlab drift = %.9f.\n', drift);
fprintf('Razor meanreversion = 0.271715892.\n');
fprintf('Matlab meanreversion = %.9f.\n', meanreversion);
fprintf('Razor vol = 0.00053563.\n');
fprintf('Matlab vol = %.9f.\n', vol);

n1 = length(rate1ran1);
sim1 = [-0.0013*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatenormal(rate1ran1(i),sim1(i,1),drift,meanreversion,vol,1/365);
end
sim1 = sim1/-0.0013;
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(rate1sim1-sim1,2));
n2 = length(rate1ran2);
sim2 = [sim1.*ones(n1,1)*-0.0013 zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatenormal(rate1ran2(i),sim1(i,1)*-0.0013,drift,meanreversion,vol,1/365);
end
sim2 = sim2./-0.0013;
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(rate1sim2-sim2,2));

% -------- Lognormal Mean Reversion Model --------
fprintf('-------- Lognormal Mean Reversion Model --------\n');
P = estimatenormalrevert(flipud(rate2historical),252);
drift = P(1);
meanreversion = P(2);
vol = P(3);
fprintf('Razor drift = -44.83802588.\n');
fprintf('Matlab drift = %.9f.\n', drift);
fprintf('Razor meanreversion = 14.79167787.\n');
fprintf('Matlab meanreversion = %.9f.\n', meanreversion);
fprintf('Razor vol = 0.648681025.\n');
fprintf('Matlab vol = %.9f.\n', vol);

n1 = length(rate2ran1);
sim1 = [exp(-2.923411612)*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatelognormalmeanreversion(rate2ran1(i),sim1(i,1),drift,meanreversion,vol,1/365);
end
sim1 = sim1/exp(-2.923411612);
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(rate2sim1-sim1,2));
n2 = length(rate2ran2);
sim2 = [sim1.*ones(n1,1)*exp(-2.923411612) zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatelognormalmeanreversion(rate2ran2(i),sim1(i,1)*exp(-2.923411612),drift,meanreversion,vol,1/365);
end
sim2 = sim2/exp(-2.923411612);
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(rate2sim2-sim2,2));
fprintf('\n');

% -------- Correlated Rates with Unequal Data Length --------
% -------- Correlation Matrix --------
fprintf('-------- Correlted Rates with Unequal Data Length --------\n');
fprintf('-------- Correlation Matrix --------\n');
%P1 = estimate1(flipud(historical(:,1)),252);
P1 = estimate1(flipud(originalrate0),252);
b = P1(1);
sig = P1(2);
%D1 = convertnormal(1,flipud(historical(:,1)),0,b,sig,1/252);
D1 = convertnormal(1,flipud(originalrate0),0,b,sig,1/252);
%P2 = estimatenormalrevert(flipud(historical(:,2)),252);
P2 = estimatenormalrevert(flipud(originalrate1),252);
a = P2(2);
b = P2(1);
sig = P2(3);
%D2 = convertnormal(2,flipud(historical(:,2)),a,b,sig,1/252);
D2 = convertnormal(2,flipud(originalrate1),a,b,sig,1/252);
%P3 = estimatenormalrevert(flipud(historical(:,3)),252);
P3 = estimatenormalrevert(flipud(originalrate2),252);
a = P3(2);
b = P3(1);
sig = P3(3);
%D3 = convertnormal(3,exp(flipud(historical(:,3))),a,b,sig,1/252);
D3 = convertnormal(3,exp(flipud(originalrate2)),a,b,sig,1/252);
RC = [1 -0.018413149 -0.056349664;-0.018413149 1 -0.069261365;-0.056349664 -0.069261365 1];
%C = corrcoef([D1 D2 D3]);
D2 = [D2;exp(1)*ones(5,1)];
D3 = [D3;exp(1)*ones(3,1)];
C = corr([D1 D2 D3]);
fprintf('The Razor correlation matrix is:\n');
RC
fprintf('The Matlab correlation matrix is:\n');
C
[V1 D1] = eig(RC);
D1 = diag(D1);
[V2 D2] = eig(C);
D2 = diag(D2);
V2(:,2) = -V2(:,2);
fprintf('The Razor eigen values are:\n');
D1
fprintf('The Matlab eigen values are:\n');
D2
fprintf('The Razor eigen vectors are:\n');
V1
fprintf('The Matlab eigen vectors are:\n');
V2
D1 = flipud(D1);
V1 = fliplr(V1);
B1 = V1*sqrt(diag(D1))
D2 = flipud(D2);
V2 = fliplr(V2);
B2 = V2*sqrt(diag(D2))

% -------- Correlated Random Numbers Generation -------
n1 = length(randall);
n2 = length(randall)/6;
crand01 = zeros(n2,1);
crand02 = zeros(n2,1);
crand11 = zeros(n2,1);
crand12 = zeros(n2,1);
crand21 = zeros(n2,1);
crand22 = zeros(n2,1);
j = 1;
for i=1:6:n1
    crand01(j) = B1(1,:)*randall(i:i+2);
    j = j + 1;
end
crand01 = -crand01; % Razor uses negative eigenvector.
j = 1;
for i=4:6:n1
    crand02(j) = B1(1,:)*randall(i:i+2);
    j = j + 1;
end
crand02 = -crand02;
j = 1;
for i=1:6:n1
    crand11(j) = B1(2,:)*randall(i:i+2);
    j = j + 1;
end
crand11 = -crand11;
j = 1;
for i=4:6:n1
    crand12(j) = B1(2,:)*randall(i:i+2);
    j = j + 1;
end
crand12 = -crand12;
j = 1;
for i=1:6:n1
    crand21(j) = B1(3,:)*randall(i:i+2);
    j = j + 1;
end
crand21 = -crand21;
j = 1;
for i=4:6:n1
    crand22(j) = B1(3,:)*randall(i:i+2);
    j = j + 1;
end
crand22 = -crand22;

% -------- Lognormal Model --------
fprintf('-------- Lognomal Model --------\n');
P = estimate1(flipud(crate0historical),252);
mu = P(1);
vol = P(2);
fprintf('Razor mu = 0.032946408.\n');
fprintf('Matlab mu = %.9f.\n', mu);
fprintf('Razor vol = 0.088350022.\n');
fprintf('Matlab vol = %.9f.\n', vol);

n1 = length(crand01);
sim1 = simulatelognormal(crand01,ones(n1,1),mu,vol,1/365);
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(crate0sim1-sim1,2));
sim2 = simulatelognormal(crand02,sim1,mu,vol,1/365);
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(crate0sim2-sim2,2));

% -------- Normal Mean Reversion Model --------
fprintf('-------- Normal Mean Reversion Model --------\n');
P = estimatenormalrevert(flipud(rate1historical), 252);
drift = P(1);
meanreversion = P(2);
vol = P(3);
fprintf('Razor drift = -0.000264589.\n');
fprintf('Matlab drift = %.9f.\n', drift);
fprintf('Razor meanreversion = 0.271715892.\n');
fprintf('Matlab meanreversion = %.9f.\n', meanreversion);
fprintf('Razor vol = 0.00053563.\n');
fprintf('Matlab vol = %.9f.\n', vol);

n1 = length(crand11);
sim1 = [-0.0013*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatenormal(crand11(i),sim1(i,1),drift,meanreversion,vol,1/365);
end
sim1 = sim1/-0.0013;
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(crate1sim1-sim1,2));
n2 = length(rate1ran2);
sim2 = [sim1.*ones(n1,1)*-0.0013 zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatenormal(crand12(i),sim1(i,1)*-0.0013,drift,meanreversion,vol,1/365);
end
sim2 = sim2./-0.0013;
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(crate1sim2-sim2,2));

% -------- Lognormal Mean Reversion Model --------
fprintf('-------- Lognormal Mean Reversion Model --------\n');
P = estimatenormalrevert(flipud(rate2historical),252);
drift = P(1);
meanreversion = P(2);
vol = P(3);
fprintf('Razor drift = -44.83802588.\n');
fprintf('Matlab drift = %.9f.\n', drift);
fprintf('Razor meanreversion = 14.79167787.\n');
fprintf('Matlab meanreversion = %.9f.\n', meanreversion);
fprintf('Razor vol = 0.648681025.\n');
fprintf('Matlab vol = %.9f.\n', vol);

n1 = length(crand21);
sim1 = [exp(-2.923411612)*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatelognormalmeanreversion(crand21(i),sim1(i,1),drift,meanreversion,vol,1/365);
end
sim1 = sim1/exp(-2.923411612);
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(crate2sim1-sim1,2));
n2 = length(rate2ran2);
sim2 = [sim1.*ones(n1,1)*exp(-2.923411612) zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatelognormalmeanreversion(crand22(i),sim1(i,1)*exp(-2.923411612),drift,meanreversion,vol,1/365);
end
sim2 = sim2/exp(-2.923411612);
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(crate2sim2-sim2,2));
fprintf('\n');

% -------- Correct Data --------
% -------- Correlation Matrix--------
fprintf('-------- Correct Data --------\n');
fprintf('-------- Correlation Matrix --------\n');
P1 = estimate1(flipud(correcthistorical(:,1)),252);
b = P1(1);
sig = P1(2);
D1 = convertnormal(1,flipud(correcthistorical(:,1)),0,b,sig,1/252);
P2 = estimatenormalrevert(flipud(correcthistorical(:,2)),252);
a = P2(2);
b = P2(1);
sig = P2(3);
D2 = convertnormal(2,flipud(correcthistorical(:,2)),a,b,sig,1/252);
P3 = estimatenormalrevert(flipud(correcthistorical(:,3)),252);
a = P3(2);
b = P3(1);
sig = P3(3);
D3 = convertnormal(3,exp(flipud(correcthistorical(:,3))),a,b,sig,1/252);
RC = [1 0.0506906 -0.0175877;0.0506906 1 -0.0113102;-0.0175877 -0.0113102 1];
C = corrcoef([D1 D2 D3]);
C = corr([D1 D2 D3]);
fprintf('The Razor correlation matrix is:\n');
RC
fprintf('The Matlab correlation matrix is:\n');
C
[V1 D1] = eig(RC);
D1 = diag(D1);
[V2 D2] = eig(C);
D2 = diag(D2);
fprintf('The Razor eigen values are:\n');
D1
fprintf('The Matlab eigen values are:\n');
D2
fprintf('The Razor eigen vectors are:\n');
V1
fprintf('The Matlab eigen vectors are:\n');
V2
D1 = flipud(D1);
V1 = fliplr(V1);
V1(:,2) = -V1(:,2);
B1 = V1*sqrt(diag(D1));
D2 = flipud(D2);
V2 = fliplr(V2);
V2(:,2) = -V2(:,2);
B1 = V2*sqrt(diag(D2)); % B2 is changed to B1.

% -------- Correlated Random Numbers Generation -------
n1 = length(correctrandall);
n2 = length(correctrandall)/6;
crand01 = zeros(n2,1);
crand02 = zeros(n2,1);
crand11 = zeros(n2,1);
crand12 = zeros(n2,1);
crand21 = zeros(n2,1);
crand22 = zeros(n2,1);
j = 1;
for i=1:6:n1
    crand01(j) = B1(1,:)*correctrandall(i:i+2);
    j = j + 1;
end
j = 1;
for i=4:6:n1
    crand02(j) = B1(1,:)*correctrandall(i:i+2);
    j = j + 1;
end
j = 1;
for i=1:6:n1
    crand11(j) = B1(2,:)*correctrandall(i:i+2);
    j = j + 1;
end
j = 1;
for i=4:6:n1
    crand12(j) = B1(2,:)*correctrandall(i:i+2);
    j = j + 1;
end
j = 1;
for i=1:6:n1
    crand21(j) = B1(3,:)*correctrandall(i:i+2);
    j = j + 1;
end
j = 1;
for i=4:6:n1
    crand22(j) = B1(3,:)*correctrandall(i:i+2);
    j = j + 1;
end
% -------- Lognormal Model --------
fprintf('-------- Lognomal Model --------\n');
P = estimate1(flipud(correcthistorical(:,1)),252);
mu = P(1);
vol = P(2);
n1 = length(crand01);
sim1 = simulatelognormal(crand01,ones(n1,1),mu,vol,1/365);
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(correctrate0sim1-sim1,2));
sim2 = simulatelognormal(crand02,sim1,mu,vol,1/365);
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(correctrate0sim2-sim2,2));

% -------- Normal Mean Reversion Model --------
fprintf('-------- Normal Mean Reversion Model --------\n');
P = estimatenormalrevert(flipud(correcthistorical(:,2)), 252);
drift = P(1);
meanreversion = P(2);
vol = P(3);
n1 = length(crand11);
sim1 = [-0.0013*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatenormal(crand11(i),sim1(i,1),drift,meanreversion,vol,1/365);
end
sim1 = sim1/-0.0013;
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(correctrate1sim1-sim1,2));
n2 = length(rate1ran2);
sim2 = [sim1.*ones(n1,1)*-0.0013 zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatenormal(crand12(i),sim1(i,1)*-0.0013,drift,meanreversion,vol,1/365);
end
sim2 = sim2./-0.0013;
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(correctrate1sim2-sim2,2));

% -------- Lognormal Mean Reversion Model --------
fprintf('-------- Lognormal Mean Reversion Model --------\n');
P = estimatenormalrevert(flipud(correcthistorical(:,3)),252);
drift = P(1);
meanreversion = P(2);
vol = P(3);
n1 = length(crand21);
sim1 = [exp(-2.923411612)*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatelognormalmeanreversion(crand21(i),sim1(i,1),drift,meanreversion,vol,1/365);
end
sim1 = sim1/exp(-2.923411612);
sim1 = sim1(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 1 is: %d.\n', norm(correctrate2sim1-sim1,2));
n2 = length(rate2ran2);
sim2 = [sim1.*ones(n1,1)*exp(-2.923411612) zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatelognormalmeanreversion(crand22(i),sim1(i,1)*exp(-2.923411612),drift,meanreversion,vol,1/365);
end
sim2 = sim2/exp(-2.923411612);
sim2 = sim2(:,2);
fprintf('The SSE of Razor and Matlab simulated values for day 2 is: %d.\n', norm(correctrate2sim2-sim2,2));
fprintf('\n');
