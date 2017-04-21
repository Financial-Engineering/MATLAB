function p = CrankNicolson(cp,S,X,L,U,T,r,b,v,N,M)

C = zeros(2, M+1);

z = cp;

dt = T / N;
dx = v * sqrt(3 * dt);
pu = -0.25 * dt * ((v / dx)^2 + (b - 0.5 * v^2) / dx);
pm = 1 + 0.5 * dt * (v / dx)^2 + 0.5 * r * dt;
pd = -0.25 * dt * ((v / dx)^2 - (b - 0.5 * v^2) / dx);

St(1) = S * exp(-M/2*dx);
C(1,1) = max(0, z * (St(1) - X));

for i = 2:M+1
    St(i) = St(i-1) * exp(dx);
    C(1,i) = max(0, z * (St(i) - X));
end

pmd(2) = pm + pd;
p(2) = -pu * C(1,3) - (pm - 2) * C(1,2) - pd * C(1,1) - pd * (St(2) - St(1));

for j=N:-1:1
    for i=3:M
        p(i) = -pu * C(1,i+1) - (pm - 2) * C(1,i) - pd * C(1,i-1) - p(i-1) * pd / pmd(i-1);
        pmd(i) = pm - pu * pd / pmd(i-1);
    end
    for i=M-1:-1:2
        C(2,i) = (p(i) - pu * C(2,i+1)) / pmd(i);
    end
    for i=1:M+1
        C(1,i) = C(2,i);
         if (St(i) < L) || (St(i) > U)
            C(1,i) = max(S-X,0);
         end
    end
end

p = C(1, int8((M+1)/2));

end
