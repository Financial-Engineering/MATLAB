function portfolio = pip(wc,wp,S,r,sigc,sigp,KC,KP,T)
% -------------------------------------------------------------------------
% portfolio = pip(wc,wp,S,r,sigc,sigp,KC,KP,T)
% This function calculates portfolio value.
%
% portfolio = output portfolio value.
% wc = vector of call option weights.
% wp = vector of put option weights.
% S = stock price.
% r = risk-free rate.
% sigc = vector of volatility.
% sigp = vector of volatility.
% KC = vector of call strike prices.
% KP = vector of put strike prices.
% T = time to maturity.
% -------------------------------------------------------------------------

sigc = sigc(:);
sigp = sigp(:);
KC = KC(:);
KP = KP(:);
nc = min(length(wp)-1,length(wc)-1);
np = min(length(wc),length(wp)-1);
BSCtruncate = BSprice(1,S,KC,r,sigc,T);
BSCtruncate = BSCtruncate(1:nc);
BSPtruncate = BSprice(-1,S,KP,r,sigp,T);
BSPtruncate = BSPtruncate(1:np);
cbp = flipud(wp).*BSprice(-1,S,KP,r,sigp,T);
cbc = wc.*BSprice(1,S,KC,r,sigc,T);
cbp = cbp(2:length(cbp));
cbc = cbc(1:length(cbc)-1);
cbp = flipud(cbp);

portfolio = sum(cbc(1:nc)) + sum(cbp(1:np));
