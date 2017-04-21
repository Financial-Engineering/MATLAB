function P = parameters(data,maturity)
% -------------------------------------------------------------------------
% P = parameters(data,maturity)
% This function calculates the seasonal and yield parameters.
%
% P = output vector of estimated parameters.
%
% data = matrix of forward prices.
% maturity = matrix of corresponding maturity dates.
% -------------------------------------------------------------------------

n1 = size(data,1);
n2 = size(data,2);
n3 = size(maturity,1);
n4 = size(maturity,2);

if (n1~=n3)
    fprintf('Row dimensions are not correct.\n');
    return;
end
if (n2~=n4)
    fprintf('Column dimensions are not correct.\n');
    return;
end

logFbar = sum(log(data),2) / n2;
sT = sum(log(data) - repmat(logFbar,1,n2)) / n1;

gamma = repmat(logFbar,1,n2) - log(data) + repmat(sT,n1,1);

P = [sT;gamma./maturity];
