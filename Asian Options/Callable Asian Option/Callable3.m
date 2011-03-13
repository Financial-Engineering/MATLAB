
RBCdate1=datenum(2007,11,20);
RBCdate2=datenum(2007,11,21);
RBCtcdate=datenum(2006,11,21);
RBCtfdate=datenum(2005,12,21);
RBCtdate=datenum(2005,11,21);

RBCd1=(RBCdate1-RBCtdate)/365;
RBCd2=(RBCdate2-RBCtdate)/365;

RBCti=[RBCd1;RBCd2];
RBCtc=(RBCtcdate-RBCtdate)/365;
RBCtf=(RBCtfdate-RBCtdate)/365;

RBCrf1=(0.025466248-0.023574198)/(749/365-658/365)*(RBCd1-658/365)+0.023574198;
RBCrf2=(0.025466248-0.023574198)/(749/365-658/365)*(RBCd2-658/365)+0.023574198;

r=[RBCrf1;RBCrf2];

rc=(0.017673668-0.016017875)/(380/365-287/365)*(RBCtc-287/365)+0.016017875;

rff=(0.014409302-0.013884359)/(103/365-12/365)*(RBCtf-12/365)+0.013884359;

RBCvoldate1=datenum(2005,11,21);
RBCvoldate2=datenum(2006,11,21);
RBCvoldate3=datenum(2007,12,22);

RBCvold1=(RBCvoldate1-RBCtdate)/365;
RBCvold2=(RBCvoldate2-RBCtdate)/365;
RBCvold3=(RBCvoldate3-RBCtdate)/365;

RBCvol1=0.2;
RBCvol2=0.2;

sig=[RBCvol1;RBCvol2];
sigf=0.2;

n=50;
S=100;
K=100;
PC=120;
N=100;
alp=[0.5;0.5];
Spg=[];
ti = RBCti;
tff=RBCtf;
dividend=2*log(1+0.0177/2);

b=r-dividend;
bc=rc-dividend;
b=(b.*RBCti-bc*RBCtc)./(RBCti-RBCtc);
rMC=(r.*RBCti-rc*RBCtc)./(RBCti-RBCtc);
bf=rff-dividend;

sigc=0.2;
sigX=0.08;
rhoi=-0.2;
tc=RBCtc;
t=0;
T=(datenum(2007,11,21)-datenum(2005,11,21))/365;
rT=(0.025629-0.023714)/(749/365-658/365)*(T-658/365)+0.023714;
df=exp(-rMC(2)*(T-tc));
dfc=exp(-rc*(tc-t));
C=20;
