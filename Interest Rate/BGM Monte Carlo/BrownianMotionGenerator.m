%% INPUTS:
%% chol_rho = cholesky decomposition of the correlation matrix
%% sizeX = X dimension of the Brownian Motion matrix ~ N(0,Sig)
     %% sizeY = number of rows of the correlation matrix
function ret = BrownianMotionGenerator(chol_rho, sizeX, sizeY, dt)
   ret = randn(sizeX, sizeY)*chol_rho*sqrt(dt);
end
