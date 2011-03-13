%% Rebonato three parameters full rank parametrisation (6.45) p.250
%% with alpha =0 and rho_infty = 0

function ret = corr(Tj,Tk)
	beta = 0.1;
	ret=exp(-beta * abs(Tj - Tk));
    
