% Simulate correlated credit migrations for each entity according to the correlated credit risk factors, and the confidence level (e.g.
% 0.95 for performing PCA principal component analysis)
function [ut nt zt obligor_state_t] = simulateModelCreditFactor(ci, num_of_simulation_years, init_seed, simulate)
    % load all parameters
    cd 'mat files\credits\RBC test case';
    loadAllFiles;
    cd ..\..\..;
        
    [PCA_eigenvalues, PCA_eigenvectors] = PCA(M,ci); % M is the market factors input correlation matrix
    num_of_PCA_eigenvalues = length(PCA_eigenvalues);
    
    % synthesise correlated observations for all risk factors
    num_of_iterations = floor(365 * num_of_simulation_years);
    obligor_state_t = [initial_obligor_state, zeros(1,num_of_iterations-1)]; % stores all simulated credit factor in this vector
    mwts = zeros(1,num_of_PCA_eigenvalues);
    nt = zeros(1,num_of_iterations);
    ut = zeros(1,num_of_iterations);
    if (exist('init_seed', 'var'))
        obj=Random(init_seed);
    end
    
    % compute VarX, betas and alpha
    varx = sum(diag(betas' * betas * M));
    
    %c = nchoosek([1:length(market_factors_indices)], 2);
    %varx=0; % init
    %M_size = length(M);
    %for j=1:size(c,1)
    %    v = c(j,:);
    %    n = market_factors_indices(v(1)) + (market_factors_indices(v(2))-1) * M_size;
    %    varx = varx + prod(betas(v)) * M(n);
    %end
    %varx = varx * 2;
    
    scaled_betas = betas / sqrt(varx);
    if (idiosyncratic_on && (varx <= 1))
        alpha = sqrt(1-varx); 
        %scaled_betas(:) = 1;
    else
        alpha = 0;
    end    
    
    
    for i=1:num_of_iterations
        % generate delta_Xs                   
        % a row vector w(t) of uncorrelated normally distributed rv
        if (exist('init_seed', 'var')) % copy Razor's normal number generator
            for k=1:num_of_PCA_eigenvalues
                mwts(k) = obj.nextn;
            end
        else % use matlab default
            mwts = randn(1,num_of_PCA_eigenvalues);
        end
        
        mzts = generateCorrelatedNormalRvs(mwts, PCA_eigenvalues, PCA_eigenvectors);
        %if(exist('testt', 'var'))
        %    testt = [testt mzts];
        %else
        %    testt = mzts;
        %end
        
        % compute correlated uniformly-distributed rv
        if (exist('init_seed', 'var'))
            wt = obj.nextn;
        else
            wt = randn;
        end
                
        nt(i) =  scaled_betas * mzts(market_factors_indices) + alpha * wt;        
        ut(i) = normal2uniform(nt(i));
        
        % generate simulations - only run if asked to
        if (exist('simulate', 'var'))
            obligor_state_t(i+1) = simulate(obligor_state_t(i), ut(i), T);
        end
    end
    
    zt = standardizeNormal(nt);
    %ut = normal2uniform(zt);
end
