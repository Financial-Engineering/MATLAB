function f = LevyIntegral(CP,x,K,c,mu,vol)
% -------------------------------------------------------------------------
% f = LevyIntegral('CP',x,K,c,mu,vol)
% This function defines the payoff times the pdf.
%
% CP =  'c' if it is a call; 'p' if it is a put.
% x =   the dummy variable.
% K =   the strike price.
% c =   (m+1)/(n+1)*Sa;
% mu =  the mean parameter.
% vol = the volatility parameter.
% -------------------------------------------------------------------------

pdf = (1./(x*vol*sqrt(2*pi))).*exp(-(log(x)-mu).^2/(2*vol^2));
if CP == 'c'
    f = (x+c-K).*pdf;
else
    f = (K-(x+c)).*pdf;
end

end
