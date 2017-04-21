% convert from standard normal to uniform random variable
function[u] = normal2uniform(z)
    u = (erf(z/sqrt(2)) + 1) / 2;
end