function A = eigenFactorise(C,F)
% -------------------------------------------------------------------------
% A = eigenFactorise(C,F)
% This function factorises the covariance matrix using eigen values
% decomposition.
%
% D = the output factorised matrix.
% C = the covariance matrix.
% F = number of random numbers per step.
% -------------------------------------------------------------------------
    [A p] = chol(C);
    n = length(C);
    if (p~=0)
        fprintf('The covariance matrix is not positive definite.\n');
        return;
    end
    if (norm(C-C',inf)>10^-10)
        fprintf('The covariance matrix is not symmetric.');
    end
    if (F>length(C))
        fprintf('F cannot be bigger than the covariance matrix dimension.\n');
    end

    [V D] = eig(C);
    factorise = V*sqrt(D);
    factorise = factorise(:,n-F+1:n);

    A = factorise;
end
