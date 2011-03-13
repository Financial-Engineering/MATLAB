% Cumulative normal distribution
function y = cnorm(x)
    y = 0.5 * (1 + erf(x / sqrt(2)));
end
