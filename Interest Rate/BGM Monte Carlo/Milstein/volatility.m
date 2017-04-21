%% Parametric volatility as defined in (6.12) Formulation 6
%% Correspond to the non-parameteric piecewise-constant models for volatilities (6.20)

function ret = volatility(Tj,T_o)
	a = -0.05;
	b = 0.5;
	c = 1.5;
	d = 0.15;
	kj = 1;
	ret=kj * ((a + b * (Tj - T_o)).* exp(-c * (Tj - T_o)) + d);
    
