% This program tests basketfloor with Razor.

ffs = 1;
L = [0.01311729*ones(2,1) 0.01248729*ones(2,1) 0.01182199*ones(2,1) 0.01108056931791*ones(2,1)];
K = 0.01;
sigG = 0.513*ones(4,1);
sigb = 0.363*ones(4,1);
s = 0;
df = [0.982560196;0.962940375;0.944188271;0.925297561];
w = [0.5 0.5];
F = 0.01;
float = [];
TT = [0.49863 1 1.49863 2];
basket(ffs,L,K,sigb,sigG,s,df,w,F,float,TT)
