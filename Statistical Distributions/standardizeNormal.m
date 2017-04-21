function[z] = standardizeNormal(n)
    mu = mean(n);
    sigma = std(n);
    z = (n-mu)/sigma;
end