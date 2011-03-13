% This program runs a test case on local volatility function code.

S0 = 50;
r = 0.05;
S = 30;
t = linspace(0,1,1000);
for i=1:1000
    z(i) = local(S0,r,S,t(i));
end
plot(t,z);
xlabel('Time');
ylabel('Local Volatility');
title('Local Volatility vs Time');
