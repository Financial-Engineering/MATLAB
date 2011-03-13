
RBCdate1=datenum(2007,11,20);
RBCdate2=datenum(2007,11,21);
RBCtdate=datenum(2005,11,21);

RBCd1=(RBCdate1-RBCtdate)/365;
RBCd2=(RBCdate2-RBCtdate)/365;

RBCti=[RBCd1;RBCd2];

RBCrd1=(0.035363884-0.033172376)/(731/365-563/365)*(RBCd1-563/365)+0.033172376;
RBCrd2=(0.035363884-0.033172376)/(731/365-563/365)*(RBCd2-563/365)+0.033172376;

rd=[RBCrd1;RBCrd2];

RBCrf1=(0.025466248-0.023574198)/(749/365-658/365)*(RBCd1-658/365)+0.023574198;
RBCrf2=(0.025466248-0.023574198)/(749/365-658/365)*(RBCd2-658/365)+0.023574198;

rf=[RBCrf1;RBCrf2];

RBCvoldate1=datenum(2005,11,21);
RBCvoldate2=datenum(2006,11,21);
RBCvoldate3=datenum(2007,12,22);

RBCvold1=(RBCvoldate1-RBCtdate)/365;
RBCvold2=(RBCvoldate2-RBCtdate)/365;
RBCvold3=(RBCvoldate3-RBCtdate)/365;

RBCvol1=sqrt((0.32596012^2-0.3^2)/(RBCvold3-RBCvold2)*(RBCd1-RBCvold2)+0.3^2);
RBCvol2=sqrt((0.32596012^2-0.3^2)/(RBCvold3-RBCvold2)*(RBCd2-RBCvold2)+0.3^2);

sig=[RBCvol1;RBCvol2];

S=100;
K=100;
N=100;
alp=[0.5;0.5];
Spg=[];
ti = RBCti;
r=rd;
dividend = 2*log(1+0.0177/2);

sigX=0.08;
rhoi=-0.2;
b=rf-dividend-rhoi*sig*sigX;
t=0;
T=(datenum(2007,11,21)-datenum(2005,11,21))/365;
rT=rd(2);
df=exp(-rT*T);
