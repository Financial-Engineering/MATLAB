% This program tests the commodity forward simulation code.

% This section defines variables and simulate the forward rates.
m = 3.06;
alpha = 3.08;
sig = 0.25;
sT = [0.25;0.18;-0.05;-0.12;-0.15;-0.18;-0.18;-0.19;-0.03;0.1;0.18;0.28];
ita = [0.25;0.09;0.05;0.045;0.04;0.035;0.03;0.025;0.025;0.025;0.025;0.025];
a = 0.5*ones(12,1);
T = 1/12*[1;2;3;4;5;6;7;8;9;10;11;12];
fT = [28.4;26.5;21;19.6;19;18.5;18.5;18.5;21.5;24.5;26.5;29.2];
t = 1;
forward1(fT,sT,alpha,m,sig,a,ita,T,t);

% Ploting the forward curve.
%{
rate = zeros(12,t/T(1));
N = 100;
for i=1:N
    rate = rate + forward1(fT,sT,alpha,m,sig,a,ita,T,t);
end
rate = rate / N
for i=1:t/T(1)
    figure(i)
    plot(T,rate(:,i));
    title('Commodity Forward Curve');
    xlabel('Time');
    ylabel('Forward Price');
end
%}
% Testing for seasonal parameters.
t=100;
simrate = forward1(fT,sT,alpha,m,sig,a,ita,T,t);
fbar = mean(simrate);
sThat = zeros(12,1);
for i=1:t/T(1)
    for j=1:12
        if (j-mod(i,12)>0)
            sThat(j) = sThat(j) + log(simrate(j-mod(i,12),i))-log(fbar(i));
        else
            sThat(j) = sThat(j) + log(simrate(j-mod(i,12)+12,i))-log(fbar(i));
        end
    end
end
sThat = sThat / (t/T(1))

P = estimatenormalrevert(log(fbar),12);
P = [P(1)/P(2);P(2);P(3)]

% Testing for convenience yield parameters.
yield = zeros(length(T),t/T(1));
for i=1:t/T(1)
    for j=1:12
        if (j+mod(i,12)<=12)
            yield(j,i) = log(fbar(i)/simrate(j,i)) + sT(j+mod(i,12));
        else
            yield(j,i) = log(fbar(i)/simrate(j,i)) + sT(j+mod(i,12)-12);
        end
    end
end
yield = yield./repmat(T,1,t/T(1));
P = estimatenormalrevert1(yield(1,:),12)

correlatedrates = forwardcorrelated(fT,sT,alpha,m,sig,a,ita,15,0.5,15,0.15,0.5,T,t);
firstrate = correlatedrates(13,:)';
secondrate = correlatedrates(14,:)';
df1 = firstrate(2:t/T(1))-firstrate(1:(t/T(1)-1));
df2 = secondrate(2:t/T(1))-secondrate(1:(t/T(1)-1));
dt = T(1);
W1 = (df1 - alpha*(m-firstrate(1:(t/T(1)-1)))*dt)/(sig*sqrt(dt));
W2 = (df2 - 0.5*(15-secondrate(1:(t/T(1)-1)))*dt)/(0.15*sqrt(dt));
correlation = cov([W1 W2])./[var(W1) std(W1)*std(W2);std(W1)*std(W2) var(W2)]
