% Double barrier digital knock-out call 
% Hui(1996)- One-Touch Barrier Binary Option Values
function [ c ] = dbldigkoc( S,K,L,U,r,b,sig,T )

    sigsq = sig * sig;
    Z = log(U / L);
    alpha = -0.5 * (2 * b / sigsq - 1);
    beta = -0.25 * (2 * b / sigsq - 1)^2 - 2 * r / sigsq;
    gamma = pi * log(S / L) / Z;
    
    sla = (S/L)^alpha;
    sua = (S/U)^alpha;
    
    % number of terms in series
    i = 1:5;
    
    c = sum((2 * pi * i * K) / (Z * Z) .* ((sla - (-1).^i * sua) ./ (alpha * alpha + (i * pi / Z).^2)) ...
    	.* sin(i * gamma) .* exp(-0.5 * ((i * pi / Z).^2 - beta) * sigsq * T));
end