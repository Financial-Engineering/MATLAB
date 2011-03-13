function P = revertregression(dx,x,dt)
% -------------------------------------------------------------------------
% P = revertregression(dx,x,dt)
% This function estimates the mean reversion parameters using regression.
%
% P = output vector of estimated parameters.
% dx = change in x values.
% x = x values.
% dt = time interval.
% -------------------------------------------------------------------------

dx = dx(:);
x = x(:);
ndx = length(dx);
A = [ones(ndx,1) x];
beta = A \ dx;

alpha = beta(2)/dt;
m = beta(1)/(alpha*dt);

residual = dx - beta(1) - beta(2)*x;
sig = var(residual);
sig = sig / sqrt(dt);

P = [m,alpha,sig];
