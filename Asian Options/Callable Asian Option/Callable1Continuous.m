
RBCdate1=datenum(2007,11,20);
RBCdate2=datenum(2007,11,21);
RBCtcdate=datenum(2006,11,21);
RBCtdate=datenum(2005,11,21);

RBCd1=(RBCdate1-RBCtdate)/365;
RBCd2=(RBCdate2-RBCtdate)/365;

RBCti=[RBCd1;RBCd2];
RBCtc=(RBCtcdate-RBCtdate)/365;

RBCrd1=(0.035363884-0.033172376)/(731/365-563/365)*(RBCd1-563/365)+0.033172376;
RBCrd2=(0.035363884-0.033172376)/(731/365-563/365)*(RBCd2-563/365)+0.033172376;

rd=[RBCrd1;RBCrd2];

rdc=(0.030956309-0.02980425)/(380/365-291/365)*(RBCtc-291/365)+0.02980425;

RBCrf1=(0.025466248-0.023574198)/(749/365-658/365)*(RBCd1-658/365)+0.023574198;
RBCrf2=(0.025466248-0.023574198)/(749/365-658/365)*(RBCd2-658/365)+0.023574198;

rf=[RBCrf1;RBCrf2];

rfc=(0.017673668-0.016017875)/(380/365-287/365)*(RBCtc-287/365)+0.016017875;

RBCvoldate1=datenum(2005,11,21);
RBCvoldate2=datenum(2006,11,21);
RBCvoldate3=datenum(2007,12,22);

RBCvold1=(RBCvoldate1-RBCtdate)/365;
RBCvold2=(RBCvoldate2-RBCtdate)/365;
RBCvold3=(RBCvoldate3-RBCtdate)/365;

RBCvol1=sqrt((0.32596012^2-0.3^2)/(RBCvold3-RBCvold2)*(RBCd1-RBCvold2)+0.3^2);
RBCvol2=sqrt((0.32596012^2-0.3^2)/(RBCvold3-RBCvold2)*(RBCd2-RBCvold2)+0.3^2);

sig=[RBCvol1;RBCvol2];

n=1000;
S=100;
K=100;
PC=120;
N=100;
alp=[0.5;0.5];
Spg=[];
ti = RBCti;
r=rd;
dividend = 2*log(1+0.0177/2);
b=r-rf-dividend;
bc=rdc-rfc-dividend;

sigc=0.3;
sigX=0.08;
rhoi=-0.2;
b=rf-dividend-rhoi*sig*sigX;
bc=rfc-dividend-rhoi*sigc*sigX;
b = (b.*RBCti-bc*RBCtc)./(RBCti-RBCtc);
rd = (rd.*RBCti-rdc*RBCtc)./(RBCti-RBCtc);
sig = sqrt(((sig.^2).*RBCti-0.3^2*RBCtc)./(RBCti-RBCtc));
tc=RBCtc;
t=0;
T=(datenum(2007,11,21)-datenum(2005,11,21))/365;
rT=rd(2);
df=exp(-rT*(T-tc));
dfc=exp(-rdc*(tc-t));
C=120;
