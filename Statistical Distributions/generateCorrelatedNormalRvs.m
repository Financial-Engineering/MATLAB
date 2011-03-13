function [z] = generateCorrelatedNormalRvs(w, lambda, x)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>w</td><td>inputs</td></tr>
% <tr><td>lamda</td><td>eigenvalues</td></tr>
% <tr><td>x</td><td>eigenvectors</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>z</td><td>correlated normally distributed random variates</td></tr>
% </table>
% </html>
%
%%
    z = x * sqrt(lambda) * w'; % VD^(1/2)w' - correlated z(t) for each risk factor
end