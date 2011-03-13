function P = DARO(beta,S,K,w1,w2,alp1,alp2,Spg1,Spg2,r,b,sig,n1,n2,ti1,ti2,t,T)
% -------------------------------------------------------------------------
% P = LevyFixEqual(beta,S,K,w1,w2,alp1,alp2,Spg1,Spg2,r,b,sig,n1,n2,ti1,ti2,t,T)
% This function calculates the double average rate option price
% for single underlying asset with arithmetic average.
%
% beta =  1 if it is a call; -1 if it is a put.
% S =   the current asset price.
% K =   the strike price.
% w1 =  weights on the first average.
% w2 =  weights on the second average.
% alp1 = the array of normalised weights in the first average.
% alp2 = the array of normalised weights in the second average.
% Spg1 = the array of observed fixings in the first average.
% Spg2 = the array of observed fixings in the second average.
% r =   the risk-free rate.
% b =   the cost of carry.
% sig = the volaitlity.
% n =   total number of fixings minus one.
% ti1 = array of time in to the ith fixing from
%       contract origination date for the first average.
% ti2 = array of time in to the ith fixing from
%       contract origination date for the first average.
% t =   the current time measured from contract initiation date.
% T =   the original time to maturity.
% -------------------------------------------------------------------------

if (beta ~= 1 && beta ~= -1)
    fprintf('Call/Put beta must be 1 or -1');
    return;
end

if(t>ti1(1))
    Spg1 = Spg1;
elseif (t==ti1(1))
    Spg1 = S;
else
    Spg1 = [];
end

if(t>ti2(1))
    Spg2 = Spg2;
elseif (t==ti2(1))
    Spg2 = S;
else
    Spg2 = [];
end

tau = T - t;

m1 = length(Spg1);
if (m1~=0)
    alpm1 = alp1(1:m1,:);
    Stmbar1 = alpm1'*Spg1;
else
    Stmbar1 = 0;
end

m2 = length(Spg2);
if (m2~=0)
    alpm2 = alp2(1:m2,:);
    Stmbar2 = alpm2'*Spg2;
else
    Stmbar2 = 0;
end

alpmlater1 = alp1(m1+1:n1);
tafter1 = ti1(m1+1:n1);
sum1 = S*alpmlater1'*exp(b*(tafter1-t));
EStnbar1 = Stmbar1 + sum1;

alpmlater2 = alp1(m2+1:n2);
tafter2 = ti1(m2+1:n2);
sum2 = S*alpmlater2'*exp(b*(tafter2-t));
EStnbar2 = Stmbar2 + sum2;

doublesum1 = 0;
for i = m1+1:n1
    for j = m1+1:n1
        doublesum1 = doublesum1 + ...
            alp1(i)*alp1(j)*S^2*exp(b*(ti1(i)+ti1(j)-2*t))* ...
            exp(sig^2*min(ti1(i)-t,ti1(j)-t));
    end
end

EStnbar1sqr = Stmbar1^2 + 2*Stmbar1*sum1 + doublesum1;

doublesum2 = 0;
for i = m2+1:n2
    for j = m2+1:n2
        doublesum2 = doublesum2 + ...
            alp2(i)*alp2(j)*S^2*exp(b*(ti2(i)+ti2(j)-2*t))* ...
            exp(sig^2*min(ti2(i)-t,ti2(j)-t));
    end
end

EStnbar2sqr = Stmbar2^2 + 2*Stmbar2*sum2 + doublesum2;

crosssum = 0;
for i = m1+1:n1
    for j = m2+1:n2
        crosssum = crosssum + ...
            alp1(i)*alp2(j)*S^2*exp(b*(ti1(i)+ti2(j)-2*t))* ...
            exp(sig^2*min(ti1(i)-t,ti2(j)-t));
    end
end

ES1S2 = Stmbar1*Stmbar2 + Stmbar1*sum2 + Stmbar2*sum1 + crosssum;

mu = w1*EStnbar1 - w2*EStnbar2;

v = w1^2*(EStnbar1sqr - EStnbar1^2) + w2^2*(EStnbar2sqr - EStnbar2^2)- ...
    2*w1*w2*(ES1S2 - EStnbar1*EStnbar2);

price = exp(-r*tau)*(sqrt(v/(2*pi))*exp(-1/2*(K-mu)^2/v)+ ...
    (mu-K)*((1+beta)/2-normcdf((K-mu)/sqrt(v))));

if (beta==1)
    fprintf('The DARO call price = %.4f\n', price);
else
    fprintf('The DARO put price = %.4f\n', price);
end
