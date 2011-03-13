function f = ReciprocalIntegral1(CP,x,K,c,mu,vol)
% -------------------------------------------------------------------------
% f = ReciprocalIntegral1('CP',x,K,c,mu,vol)
% This function defines the payoff times the pdf.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% x =   the dummy variable.
% K =   the strike price.
% c =   (m+1)/(n+1)*Sa;
% mu =  the mean parameter.
% vol = the volatility parameter.
% -------------------------------------------------------------------------

%pdf = (1./(x*vol*sqrt(2*pi))).*exp(-(log(x)-mu).^2/(2*vol^2));
%if CP == 'c'
%    f = (1./(1/5*x+c)-1/K).*pdf;
%else
%    f = (1/K-1./(1/5*x+c)).*pdf;
%end
f=x.^3;

end
