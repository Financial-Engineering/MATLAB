function [lambda, v] = PCA(M, ci)

%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>M</td><td>Input matrix for reduction</td></tr>
% <tr><td>ci</td><td>Confidence interval</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>eigenvalues</td><td>Most dominant eigenvalues according to ci</td></tr>
% <tr><td>eigenvectors</td><td>Most dominant eigenvectors according to
% ci</td></tr>
% </table>
% </html>

    %%
    % eigendecomposition
    [V,D] = eig(M);
    evs = diag(D);
    [evs_ordered evs_index] = sort(evs, 'descend'); % ordered eigenvalues by magnitude in decending order    
    V = V(:,evs_index); % re-order V
    
    % PCA
    evs_sum = sum(evs_ordered);
    parfor i=1:length(D)
        partial_evs_sum(i) = sum(evs_ordered(1:i)); % calc all partial sums
    end
    meetCi = (partial_evs_sum / evs_sum) >= ci; % find those larger than the user-defined confidence interval
    num_of_PCA_eigenvalues = findIndexOfValue(1, meetCi', 'first'); % need only this many eigenvalues to represent ci (%) of total eigenvalues sum 
    PCA_eigenvalues = evs_ordered(1:num_of_PCA_eigenvalues);
    v = V(:,1:num_of_PCA_eigenvalues);   
    lambda = diag(PCA_eigenvalues);
end