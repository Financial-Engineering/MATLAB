function f = lognormalpdf(CP,x,k,c,mu,vol)
% -------------------------------------------------------------------------
% f = lognormal(x,mu,vol)
% This function defines the payoff multiply the pdf.
% CP =  'c' if it is a call; 'p' if it is a put.
% x =   the dummy variable.
% K =   the strike price.
% mu =  the mean parameter.
% vol = the volatility parameter.
% -------------------------------------------------------------------------

f = (1./(x*vol*sqrt(2*pi))).*exp(-(log(x)-mu).^2/(2*vol^2));

end