function WV = correlatedWiener(points,A,F)
% -------------------------------------------------------------------------
% WV = correlatedWiener(ponts,A,F)
% This function generates the correlated Wiener vector.
%
% WV = the output Wiener vector.
% points = 'sobol' if using sobol pooints; 'quasi' if using quasi random
% numbers.
% A = the factorised matrix.
% F = number of random numbers per step.
% -------------------------------------------------------------------------

if (points=='s')
    WV = A*norminv(sobol(F,1),0,1);
elseif (points=='q')
    WV = A*randn(F,1);
else
    fprintf('Points can only be sobol or quasi.\n');
    return
end
