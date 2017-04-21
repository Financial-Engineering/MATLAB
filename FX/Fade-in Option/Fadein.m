
function P = Fadein(cp,io,ud,r,rf,vol,df,S,h,K,T1,T2)

% -------------------------------------------------------------------------
% P = Fadein(cp,io,ud,r,rf,vol,df,S,h,K,T1,T2,t0,T)
%
% Author: Richard Lewis
%
% This function calculates the prices for a foreign exchange
% fade-in option.
%
% P = output of fade-in option price.
%
% cp = 1 if it is call; -1 if it is put.
% i0 = 1 if it is knock-in; -1 if it is knock-out.
% ud = 1 if it is in type; -1 if it is out type.
% r = vector of domestic risk-free rate.
% rf = vector of foreign risk-free rate.
% vol = vector of volatilities.
% df = domestic discount factor.
% S = current underlying asset price.
% h = barrier.
% K = the strike price.
% T1 = barrier observation date.
% T2 = option maturity date.
% T = settlement date.
% -------------------------------------------------------------------------

if (cp ~= 1 && cp ~= -1)
    fprintf('cp must be 1 or -1.\n');
    return;
end

if (io ~=1 && io ~= -1)
    fprintf('ip must be 1 or -1.\n');
    return;
end

if (ud ~= 1 && ud ~= 0)
    fprintf('ud must be 1 or 0.\n');
    return;
end

F1 = S*exp((r(1)-rf(1))*T1);
F2 = S*exp((r(2)-rf(2))*T2);

v1 = vol(1)^2*T1;
m1 = log(F1) - 1/2*v1;
v2 = vol(2)^2*T2 - vol(1)^2*T1;

alpha = (log(h)-m1)/sqrt(v1) - sqrt(v1);
alphad = (log(h)-m1)/sqrt(v1);

gamma = cp*((log(F2/K)+(v1+v2)/2)/sqrt(v1+v2));
gammad = cp*((log(F2/K)-(v1+v2)/2)/sqrt(v1+v2));

rho = -cp*sqrt(v1/(v1+v2));

N1 = CDFBVNorm(alpha,gamma,rho);
N2 = CDFBVNorm(alphad,gammad,rho);
N3 = CDFBVNorm(-alpha,gamma,-rho);
N4 = CDFBVNorm(-alphad,gammad,-rho);

P = df*(((1+io)/2-io*ud)*cp*(F2*N1-K*N2) + ... 
    ((1-io)/2+io*ud)*cp*(F2*N3-K*N4));
end
