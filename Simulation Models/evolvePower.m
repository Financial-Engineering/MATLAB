% Power Evolve - y = a(x ^ t)
function [y] = evolvePower(x, a, t)
    y = a .* (x .^ t);
end
