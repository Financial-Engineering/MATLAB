% This program tests the inflation derivative pricing models.

% Year-on-Year Inflation Swap
% yyis(a,ai,sig,sigi,rho,PT1,PiT1,PiT2,T1,T2)
yyis(1,1,0.5,0.5,1,0.9,1,1,1,2)

% Inflation Option
% ioption(ita,K,ai,sigi,PT,IT0,PiT,T)
ioption(1,1,1,0.5,0.9,0.9,0.9,1)-ioption(-1,1,1,0.5,0.9,0.9,0.9,1)
0.9/0.9-1*0.9

% Inflation Caplet and Floorlet
% icf(ita,K,a,ai,sig,sigi,rho,PT1,PT2,PiT1,PiT2,T1,T2)
icf(1,0.05,1,1,0.5,0.5,1,0.9,0.8,1,1,1,2)-icf(-1,0.05,1,1,0.5,0.5,1,0.9,0.8,1,1,1,2)
0.9-0.8*(1+0.05*1)
