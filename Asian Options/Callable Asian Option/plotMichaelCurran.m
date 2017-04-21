function f = plotMichaelCurran(CP,K,alp,Spg,df,r,b,sig,ti,t,T,C)
% This function plots the Michael Curran prices with different stock prices.

S = linspace(1,500,1000);
for n=1:1000
    y(n) = MichaelCurran(S(n),CP,K,alp,[],df,r,b,sig,ti,t,T);
end

plot(S,y,'b-',S,C,'y');
title('Michael Curran Prices with Different Stock Prices');
xlabel('Stock Price')
ylabel('Michael Curran Price')
legend('Michael Curran Price','Call Premium','Location','SouthWest');
