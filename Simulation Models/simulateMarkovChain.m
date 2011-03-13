% (Markov chain simulation) Transite from start state to end_state based on
% the transition matrix T and theuniformly distributed random variates u.
function [y] = simulateMarkovChain(x, u, T)
    to_state_probs = T(x,:); % a row vector containing all the transition probabilities for the ith entity
    to_state_cum_probs = cumsum(to_state_probs);
    y = findIndexOfValue(1, to_state_cum_probs > u, 'first'); % the uniform rv falls in this state bucket - so transit to this state
end
