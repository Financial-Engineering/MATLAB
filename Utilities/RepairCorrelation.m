%% RepairCorrelation
% Repairs a correlation matrix to ensure it is Hermitian

function [C] = RepairCorrelation(D)
    [V,L]=eig(D);
    if any(L(:) < 0) % skip if no negative eigenvalues
        L=max(L,0); % set any negative values to zero
        BB=V*L*V';  % recompose matrix
        
        % Scale matrix to force diagonals to 1.0
        T = 1./sqrt(diag(BB));
        TT = T * T';
        C = BB .* TT;
    else
        C = D;
    end
end
