% Simulate correlated credit migrations for each entity according to the correlated credit risk factors, and the confidence level (e.g.
% 0.95 for performing PCA principal component analysis)
function [obligor_state_t] = simulateStandardCreditFactor(ci, num_of_simulation_years, simulate)
    % load all parameters
    cd 'mat files\credits';
    loadAllFiles;
    cd ..\..

    [PCA_eigenvalues, PCA_eigenvectors] = PCA(CM, ci); % Do PCA on CM - the correlation matrix between this credit factor and all the market factors it has correlations with   
    
    % synthesise correlated observations for all risk factors
    num_of_iterations = floor(252 * num_of_simulation_years);
    obligor_state_t = [initial_obligor_state, zeros(1,num_of_iterations-1)]; % stores all simulated obligor states in this vector
    
    for i=1:num_of_iterations
        num_of_PCA_eigenvalues = length(PCA_eigenvalues);
        wts = randn(1, num_of_PCA_eigenvalues); % a row vector w(t) of uncorrelated normally distributed rv
        uts = generateCorrelatedUniformRvs(wts, PCA_eigenvalues, PCA_eigenvectors);
        % generate simulations
        obligor_state_t(i+1) = simulate(obligor_state_t(i), uts(1), T); % only the first element (credit factor) of uts is used for transitioning, others (market factors) are not used
    end    
    
end





