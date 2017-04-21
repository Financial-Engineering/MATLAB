function [V,d,C]=factorReturns(R, p)
    
    % Calculate returns
    r = diff(R)./R(1:end-1,:);
    
    % Correlate returns
    C = corrcoef(r);
    
    % Eigen decomp
    [V,D] = eig(C);
    d = diag(D);
    
    % Only allow eigen values that contribute > p
    d = d(cumsum(d)/sum(d) > p);
    V = V(:,1:size(d));
end
