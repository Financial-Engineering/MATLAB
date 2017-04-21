% This program tests the rangeaccrul program.
load ratedfvolbmaxbminti.txt;
load dffixTT.txt;
%ffs = 1;
%L = 0.05*ones(8,1);
%Bmax = 0.051*ones(8,1);
%Bmin = 0.049*ones(8,1);
%Rfix = 0.05;
%F = 0.05*ones(8,1);
%s = 0;
%df1 = ones(8,1);
%df2 = ones(4,1);
%sig = 0.25*ones(8,1);
%ti = linspace(0.5,4,8);
%TT = linspace(1,4,4);
%rangeaccrual(ffs,L,Bmax,Bmin,Rfix,F,s,df1,df2,sig,ti,TT)

ffs = 1;
L = ratedfvolbmaxbminti(:,1);
Bmax = ratedfvolbmaxbminti(:,4);
Bmin = ratedfvolbmaxbminti(:,5);
Rfix = 0.012;
F = zeros(30,1);
s = 0;
df1 = ratedfvolbmaxbminti(:,2);
df2 = dffixTT(:,1);
sig = ratedfvolbmaxbminti(:,3);
ti = ratedfvolbmaxbminti(:,6);
TT = dffixTT(:,3);
rangeaccrual(ffs,L,Bmax,Bmin,Rfix,F,s,df1,df2,sig,ti,TT)
