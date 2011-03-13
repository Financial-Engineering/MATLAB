% This program simulates the correlated risk factors.

randomnumber1 = randn(5,100);
randomnumber2 = randn(5,100);
C = [1 exp(-0.2*1) exp(-0.2*2) exp(-0.2*3) exp(-0.2*4);exp(-0.2*1) 1 exp(-0.2*1) exp(-0.2*2) exp(-0.2*3);exp(-0.2*2) exp(-0.2*1) 1 exp(-0.2*1) exp(-0.2*2);exp(-0.2*3) exp(-0.2*2) exp(-0.2*1) 1 exp(-0.2*1);exp(-0.2*4) exp(-0.2*3) exp(-0.2*2) exp(-0.2*1) 1];
[V D] = eig(C);
B = V*sqrt(D);
for i=1:100
    randomnumber1(:,i) = B*randomnumber1(:,i);
    randomnumber2(:,i) = B*randomnumber2(:,i);
end
% -------------------------------------------------------------------------
n1 = size(randomnumber1(1,:),2);
sim1 = simulatelognormal(randomnumber1(1,:),ones(n1,1),0.032946408,0.088350022,1/365);
sim1 = sim1(:,2);
sim2 = simulatelognormal(randomnumber2(2,:),sim1,0.032946408,0.088350022,1/365);
sim2 = sim2(:,2);
[sim1 sim2]
% -------------------------------------------------------------------------
n1 = size(randomnumber1(2,:),2);
sim1 = [-0.0013*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatenormal(randomnumber1(2,i),sim1(i,1),-0.000264589,0.271715892,0.00053563,1/365);
end
sim1 = sim1/-0.0013;
sim1 = sim1(:,2);
sim2 = [sim1.*ones(n1,1)*-0.0013 zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatenormal(randomnumber2(2,i),sim1(i,1)*-0.0013,-0.000264589,0.271715892,0.00053563,1/365);
end
sim2 = sim2./-0.0013;
sim2 = sim2(:,2);
[sim1 sim2]
% -------------------------------------------------------------------------
n1 = size(randomnumber1(3,:),2);
sim1 = [exp(-2.923411612)*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatelognormalmeanreversion(randomnumber1(3,i),sim1(i,1),-44.83802588,14.79167787,0.648681025,1/365);
end
sim1 = sim1/exp(-2.923411612);
sim1 = sim1(:,2);
sim2 = [sim1.*ones(n1,1)*exp(-2.923411612) zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatelognormalmeanreversion(randomnumber2(3,i),sim1(i,1)*exp(-2.923411612),-44.83802588,14.79167787,0.648681025,1/365);
end
sim2 = sim2/exp(-2.923411612);
sim2 = sim2(:,2);
[sim1 sim2]
% -------------------------------------------------------------------------
n1 = size(randomnumber1(4,:),2);
sim1 = [exp(-2.923411612)*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatepathjd(randomnumber1(4,i),exp(-2.923411612),-44.83802588,14.79167787,0.648681025,1,0.3,5,1/365);
end
sim1 = sim1/exp(-2.923411612);
sim1 = sim1(:,2);
sim2 = [sim1.*ones(n1,1)*exp(-2.923411612) zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatepathjd(randomnumber2(4,i),exp(-2.923411612),-44.83802588,14.79167787,0.648681025,1,0.3,5,1/365);
end
sim2 = sim2/exp(-2.923411612);
sim2 = sim2(:,2);
[sim1 sim2]
% -------------------------------------------------------------------------
n1 = size(randomnumber1(5,:),2);
sim1 = [exp(-2.923411612)*ones(n1,1) zeros(n1,1)];
for i=1:n1
    sim1(i,2) = simulatepathperiod(randomnumber1(5,i),exp(-2.923411612),1,0,-44.83802588,14.79167787,0.648681025,1/365);
end
sim1 = sim1/exp(-2.923411612);
sim1 = sim1(:,2);
sim2 = [sim1.*ones(n1,1)*exp(-2.923411612) zeros(n1,1)];
for i=1:n1
    sim2(i,2) = simulatepathperiod(randomnumber2(5,i),exp(-2.923411612),1,0,-44.83802588,14.79167787,0.648681025,1/365);
end
sim2 = sim2/exp(-2.923411612);
sim2 = sim2(:,2);
[sim1 sim2]
