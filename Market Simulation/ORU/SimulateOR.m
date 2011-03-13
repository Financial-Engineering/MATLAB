function [ S ] = SimulateOR( S0, mu, sigma, lambda, deltaT, T) 
%% Ornstein-Uhlenbeck process. 

%% Reference 
% Based on the equation described in see 
% http://www.puc-rio.br/marco.ind/sim_stoc_proc.html#mc-mrd 
% For a formal treatment, see 
% Gillespie, D. T. 1996. 'Exact numerical simulation of the Ornstein-Uhlenbeck process 
% and its integral.' Physical review E 54, no. 2: 2084?2091. 

    periods = floor(T / deltaT);
    S = zeros(periods, 1); 
    S(1) = S0; 

    %% Calculate the random term.
    %
    % $$ dt=\left\{ \begin{array}{ll} \sqrt{\frac{1-e^{-2\lambda\Delta T}}{2\lambda}} & \lambda>0 \\ 
    % \sqrt{\Delta T} & \mbox{otherwise} \\
    % \end{array} \right. $$
    if (lambda == 0) 
        %  no mean reversion. 
        dt = sqrt(deltaT); 
    else
        dt = sqrt((1 - exp(-2 * lambda* deltaT)) / (2 * lambda)); 
    end

    dWt = randn(periods,1) * dt;
    
    eldt = exp(-lambda * deltaT); 
    
    %%
    % $$ S_{t+1} = S_t e^{-\lambda\Delta T}+\mu\left(1-e^{-\lambda\Delta
    % T}\right)+\sigma dW_{t+1} $$
    for t=1:periods-1
        S(t+1) = S(t) * eldt + mu * (1 - eldt) + sigma * dWt(t+1);
    end

    
end