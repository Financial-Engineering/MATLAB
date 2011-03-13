% This program tests the commodity forward simulation code.

% This section defines variables and simulate the forward rates.
m = 3.06;
alpha = 3.08;
sig = 0.25;
sT = [0.25;0.18;-0.05;-0.12;-0.15;-0.18;-0.18;-0.19;-0.03;0.1;0.18;0.28];
ita = [0.25;0.09;0.05;0.045;0.04;0.035;0.03;0.025;0.025;0.025;0.025;0.025];
a = 0.5*ones(12,1);
T = 1/12*[1;2;3;4;5;6;7;8;9;10;11;12];
fT = [14;16;18;20;22;24;26;28;26;24;22;20];
g0 = zeros(12,1);
forward(fT,sT,alpha,m,sig,g0,a,ita,T);

% Plotting the forward curve.
rate = zeros(12,12);
N = 100;
for i=1:N
    rate = rate + forward(fT,sT,alpha,m,sig,g0,a,ita,T);
end
rate = rate / N;
plot(T,rate(:,1));
title('Commodity Forward Curve');
xlabel('Time');
ylabel('Forward Price');

% Testing for seasonal and stochastic yield parameters.
yield = zeros(N,12);
ratediff = zeros(12,1);
for i=1:N
    rate = forward(fT,sT,alpha,m,sig,g0,a,ita,T);
    logFbar = sum(log(rate(:,1)))/12;
    yield(i,:) = transpose(logFbar - log(rate(:,1)));
    ratediff = ratediff + log(rate(:,1)) - logFbar;
end
sThat = ratediff / N
yield = yield + repmat(sThat',N,1);
for i=1:N
    yield(i,:) = yield(i,:)./T';
end
mean(yield)
