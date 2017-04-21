%OU_S = simulateModel(S0, model_parms, T, @simulateNormalMeanReverting, init_seed); % OU
%OU_S = simulateModel(S0, model_parms, T, @simulateNormalMeanReverting); % OU - with razor's normals
%LnOU_S = exp(simulateModel(log(S0), model_parms, T, @simulateNormalMeanReverting, init_seed)); % Lognotmal OU
%LnOU_S = exp(simulateModel(log(S0), model_parms, T, @simulateNormalMeanReverting)); % Lognotmal OU - with razor's normals

%N_S = simulateModel(S0, model_parms, T, @simulateNormal, init_seed); % Normal
N_S = simulateModel(S0, model_parms, T, @simulateNormal); % Normal - with razor's normals
%Ln_S = exp(simulateModel(log(S0), model_parms, T, @simulateLognormal, init_seed)); % Lognormal
%Ln_S = exp(simulateModel(log(S0), model_parms, T, @simulateLognormal)); % Lognormal - with razor's normals