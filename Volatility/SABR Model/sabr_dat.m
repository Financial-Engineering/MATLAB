%Based on paper http://www.cam.wits.ac.za/mfinance/MIF2005/WestGraeme.pdf
%Calibrates alpha,rho,nu parameters for different strikes using input data of market volatilities 

clear all;

global alpha;
global beta;
global rho;
global nu;
global T;
global S;
global r;
global MarketData;


%----------Input parameters ----------------
beta=1; %beta parameter set from backbone or aesthetics
S=22.2; %Spot price
r=0.04; %risk free rate

%market data structure is => Option Maturity in Years/ Strike/ Market Implied Volatility
%Can also be captured by copying data from the "FilteredVols" tab after running 
%the spreadsheet in http://www.quantcode.com/modules/mydownloads/singlefile.php?cid=4&lid=21
MarketData =[ 0.078159208	17.5	0.231583868
0.078159208	20	0.194447616
0.078159208	22.5	0.180948553
0.078159208	25	0.20549825
0.078159208	27.5	0.2286896
0.078159208	30	0.254493656
0.078159208	32.5	0.283817284
0.078159208	35	0.303435636
0.58371  12.00000   0.35215
0.58371  15.00000   0.26899
0.58371  17.00000   0.24382
0.58371  19.50000   0.20943
0.58371  20.00000   0.20439
0.58371  22.00000   0.19634
0.58371  22.50000   0.19318
0.58371  24.50000   0.20162
0.58371  25.00000   0.20537
0.58371  27.00000   0.22337
0.58371  27.50000   0.22825
0.58371  29.50000   0.23799
0.58371  30.00000   0.25288
0.58371  32.00000   0.27194
0.58371  32.50000   0.27655
0.58371  34.50000   0.29436
0.58371  37.00000   0.31516
1.59483  15.00000   0.31353
1.59483  17.50000   0.26695
1.59483  20.00000   0.23042
1.59483  22.50000   0.22082
1.59483  25.00000   0.21535
1.59483  27.50000   0.23587
1.59483  30.00000   0.25090
1.59483  35.00000   0.30947
1.59483  40.00000   0.35199];

%------------------------
