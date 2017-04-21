clear all

% simple discount curve at 7% (6 months)
P=[1.000000
0.966736
0.934579
0.903492
0.873439
0.844385
0.816298
0.789145
0.762895
0.737519
0.712986
0.689270
0.666342
0.644177
0.622750
0.602035
0.582009
0.562649
0.543934
0.525841
0.508349
0.491440
0.475093
0.459290
0.444012
0.429243
0.414964
0.401161
0.387817
0.374917
0.362446
0.350390
0.338735
0.327467
0.316574
0.306044
0.295864
0.286022
0.276508
0.267311
0.258419
0.249823]; 

T=0:0.5:20.5;
alpha=5; % 2-years
beta=17; % 8-years
tau=0.5; % 6 months

F=ForwardRate(P,tau);

swaptionVol = SwaptionVolatility(F,alpha,beta,tau,T);

K = GetSwapRate(F,alpha,beta,tau);

tmpsum=0;
for i=alpha:beta-1,
    tmpsum=tmpsum+tau*P(i+1);
end

Bl=tmpsum*Black(K,K,swaptionVol)*100;
beginning = sprintf('Swap begin= %d\t Swap end= %d\n',T(alpha),T(beta));
output2 = sprintf('Swaption price (Black)=%f\n',Bl);
disp(beginning);
disp(output2);

randn('seed',0);
A=lmmSwaptionPC(P,T,alpha,beta,tau,2000); % 2000 scenarios
output1 = sprintf('Swaption price (MC)=%f\n',A);
disp(output1);
