function [zt] = simulateModelMarketFactor(ci, num_of_simulation_years, simulate)
    % load all parameters
    cd 'mat files\market';
    loadAllFiles;
    cd ..\..
        
    [PCA_eigenvalues, PCA_eigenvectors] = PCA(M,ci); % M is the market factors input correlation matrix
    
    % synthesise correlated observations for all risk factors
    num_of_iterations = floor(252 * num_of_simulation_years);
    zt = [zeros(1,num_of_iterations-1)]; % store all simulated returns for this market factor in this vector
    
    for i=1:num_of_iterations
        % generate delta_Xs
        num_of_PCA_eigenvalues = length(PCA_eigenvalues);
        mwts = randn(1,num_of_PCA_eigenvalues); % a row vector w(t) of uncorrelated normally distributed rv
        mzts = generateCorrelatedNormalRvs(mwts, PCA_eigenvalues, PCA_eigenvectors)
        
        % computer VarX, betas and alpha
        c = nchoosek([1:length(market_factors_indices)], 2);
        varx=0; % init
        M_size = length(M);
        for j=1:size(c,1)
            v = c(j,:);
            n = market_factors_indices(v(1)) + (market_factors_indices(v(2))-1) * M_size;
            varx = varx + prod(betas(v)) * M(n);
        end
        betas = betas / sqrt(varx);
        if (idiosyncratic_on && (varx <= 1))
            alpha = sqrt(1-varx);
        else
            alpha = 0;
        end
        
        % compute model factor correlated normal rv
        wt = randn;
        zt = betas * mzts(market_factors_indices) + alpha * wt;        
    end
end