%% Evolve the forward rate based on partial sums
%
% $$ F_{i}=F_{0}e^{\sum_{0}^{i}{\lambda_i}} $$
function F=evolveMult(F0,lambda)
    F = F0 * exp(cumsum(lambda));
end
