function [rt, parms] = calcParmsMarkovChain(rk, data)
    Ms = data.transition_matrices;
    [num_of_observations num_of_risk_factors] = size(rk);
    rk_up = shift(rk, 'up');
    plain_returns = rk_up(1:end-1,:) - rk(1:end-1,:);
    
    for i=1:num_of_risk_factors % get the transition matrix for each entity from a unique set of matrices Ms, and the mappings
        rfs_Ms(:,:,i) = Ms(:,:,rf_M_mappings(i));
    end
    parms.users_transition_matrices = rfs_Ms;
end