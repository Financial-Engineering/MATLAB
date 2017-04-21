% This program tests the Geske's approximation with Razor.

load GeskeData.txt;
L1 = GeskeData(1:size(GeskeData,1),1);
L2 = GeskeData(1:size(GeskeData,1),2);
sig = GeskeData(1:size(GeskeData,1),4);
T = GeskeData(1:size(GeskeData,1),3);
1000000*Geske(L1,L2,sig,T)
1000000*Geske(0.017582,0.016789,0.345368,1.038356)
