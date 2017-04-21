function P =  PartialTimeBarrier(TypeFlag, S, X, H, t1, T2, r, b, v)

    if (strcmp(TypeFlag,'cdoA'))
        eta = 1;
    elseif (strcmp(TypeFlag,'cuoA'))
        eta = -1;
    end

    d1 = (log(S / X) + (b + v ^ 2 / 2) * T2) / (v * sqrt(T2));
    d2 = d1 - v * sqrt(T2);

    f1 = (log(S / X) + 2 * log(H / S) + (b + v ^ 2 / 2) * T2) / (v * sqrt(T2));
    f2 = f1 - v * sqrt(T2);
 
	e1 = (log(S / H) + (b + v ^ 2 / 2) * t1) / (v * sqrt(t1));
    e2 = e1 - v * sqrt(t1);
    e3 = e1 + 2 * log(H / S) / (v * sqrt(t1));
    e4 = e3 - v * sqrt(t1);

    mu = (b - v ^ 2 / 2) / v ^ 2;
    rho = sqrt(t1 / T2);

    g1 = (log(S / H) + (b + v ^ 2 / 2) * T2) / (v * sqrt(T2));
    g2 = g1 - v * sqrt(T2);
    g3 = g1 + 2 * log(H / S) / (v * sqrt(T2));
    g4 = g3 - v * sqrt(T2);

    z1 = cnorm(e2) - (H / S) ^ (2 * mu) * cnorm(e4);
    z2 = cnorm(-e2) - (H / S) ^ (2 * mu) * cnorm(-e4);
    z3 = bvnl(g2, e2, rho) - (H / S) ^ (2 * mu) * bvnl(g4, -e4, -rho);
    z4 = bvnl(-g2, -e2, rho) - (H / S) ^ (2 * mu) * bvnl(-g4, e4, -rho);
    z5 = cnorm(e1) - (H / S) ^ (2 * (mu + 1)) * cnorm(e3);
    z6 = cnorm(-e1) - (H / S) ^ (2 * (mu + 1)) * cnorm(-e3);
    z7 = bvnl(g1, e1, rho) - (H / S) ^ (2 * (mu + 1)) * bvnl(g3, -e3, -rho);
    z8 = bvnl(-g1, -e1, rho) - (H / S) ^ (2 * (mu + 1)) * bvnl(-g3, e3, -rho);

    if (strcmp(TypeFlag,'cdoA') || strcmp(TypeFlag,'cuoA')) % call down-&& out && up-&&-out type A;
        P = S * exp((b - r) * T2) * (bvnl(d1, eta * e1, eta * rho) ...
            - (H / S) ^ (2 * (mu + 1)) * bvnl(f1, eta * e3, eta * rho)) ...
			- X * exp(-r * T2) * (bvnl(d2, eta * e2, eta * rho) ...
            - (H / S) ^ (2 * mu) * bvnl(f2, eta * e4, eta * rho));
    elseif (strcmp(TypeFlag,'cdoB2') && X < H)  % call down-&&-out type B2
        P = S * exp((b - r) * T2) * (bvnl(g1, e1, rho) ...
            - (H / S) ^ (2 * (mu + 1)) * bvnl(g3, -e3, -rho)) ...
			- X * exp(-r * T2) * (bvnl(g2, e2, rho) ...
            - (H / S) ^ (2 * mu) * bvnl(g4, -e4, -rho));
    elseif (strcmp(TypeFlag,'cdoB2') && X > H)
        P = PartialTimeBarrier('coB1', S, X, H, t1, T2, r, b, v);
    elseif (strcmp(TypeFlag,'cuoB2') && X < H)  % call up-&&-out type B2
        P = S * exp((b - r) * T2) * (bvnl(-g1, -e1, rho) - (H / S) ^ (2 * (mu + 1)) * bvnl(-g3, e3, -rho)) ...
			- X * exp(-r * T2) * (bvnl(-g2, -e2, rho) - (H / S) ^ (2 * mu) * bvnl(-g4, e4, -rho)) ...
			- S * exp((b - r) * T2) * (bvnl(-d1, -e1, rho) - (H / S) ^ (2 * (mu + 1)) * bvnl(e3, -f1, -rho)) ...
			+ X * exp(-r * T2) * (bvnl(-d2, -e2, rho) - (H / S) ^ (2 * mu) * bvnl(e4, -f2, -rho));
    elseif (strcmp(TypeFlag,'coB1') && X > H)  % call out type B1;
        P = S * exp((b - r) * T2) * (bvnl(d1, e1, rho) - (H / S) ^ (2 * (mu + 1)) * bvnl(f1, -e3, -rho)) ...
			- X * exp(-r * T2) * (bvnl(d2, e2, rho) - (H / S) ^ (2 * mu) * bvnl(f2, -e4, -rho));
    elseif (strcmp(TypeFlag,'coB1') && X < H)
        P = S * exp((b - r) * T2) * (bvnl(-g1, -e1, rho) - (H / S) ^ (2 * (mu + 1)) * bvnl(-g3, e3, -rho)) ...
			- X * exp(-r * T2) * (bvnl(-g2, -e2, rho) - (H / S) ^ (2 * mu) * bvnl(-g4, e4, -rho)) ...
			- S * exp((b - r) * T2) * (bvnl(-d1, -e1, rho) - (H / S) ^ (2 * (mu + 1)) * bvnl(-f1, e3, -rho)) ...
			+ X * exp(-r * T2) * (bvnl(-d2, -e2, rho) - (H / S) ^ (2 * mu) * bvnl(-f2, e4, -rho)) ...
			+ S * exp((b - r) * T2) * (bvnl(g1, e1, rho) - (H / S) ^ (2 * (mu + 1)) * bvnl(g3, -e3, -rho)) ...
			- X * exp(-r * T2) * (bvnl(g2, e2, rho) - (H / S) ^ (2 * mu) * bvnl(g4, -e4, -rho));
    elseif (strcmp(TypeFlag,'pdoA'))  % put down-&& out && up-&&-out type A
        P = PartialTimeBarrier('cdoA', S, X, H, t1, T2, r, b, v) ...
            - S * exp((b - r) * T2) * z5 + X * exp(-r * T2) * z1;
    elseif (strcmp(TypeFlag,'puoA'))
        P = PartialTimeBarrier('cuoA', S, X, H, t1, T2, r, b, v) ...
            - S * exp((b - r) * T2) * z6 + X * exp(-r * T2) * z2;
    elseif (strcmp(TypeFlag,'poB1'))  % put out type B1
        P = PartialTimeBarrier('coB1', S, X, H, t1, T2, r, b, v) ...
            - S * exp((b - r) * T2) * z8 + X * exp(-r * T2) * z4 ...
            - S * exp((b - r) * T2) * z7 + X * exp(-r * T2) * z3;
    elseif (strcmp(TypeFlag,'pdoB2'))  % put down-&&-out type B2
        P = PartialTimeBarrier('cdoB2', S, X, H, t1, T2, r, b, v) ...
            - S * exp((b - r) * T2) * z7 + X * exp(-r * T2) * z3;
    elseif (strcmp(TypeFlag,'puoB2'))  % put up-&&-out type B2
        P = PartialTimeBarrier('cuoB2', S, X, H, t1, T2, r, b, v) ...
            - S * exp((b - r) * T2) * z8 + X * exp(-r * T2) * z4;
    end

end
