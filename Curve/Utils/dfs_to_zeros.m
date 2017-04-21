% Find the zero rates vector of the given dfs vector using the zero_treatment method. Default zero_treatment is simple. If
% zero_treatment is 'compounded', need to specify the compounding freq.
% Default is annual.
function [zs] = dfs_to_zeros(dfs, ts, zero_treatment, freq)
    if (nargin < 3)
        zero_treatment = 'simple'; % default
    end
    switch zero_treatment
        case 'simple'            
            zs = (1 ./ dfs - 1) ./ ts;
        case 'compounded'
            if (nargin < 4)
                freq = 1; % default to annual-compounding
            end
            zs = freq * (dfs .^ (-1 ./ (freq * ts)) - 1);
        case 'cont_compounded'
            zs = -(1 ./ ts) .* log(dfs);
        case 'cash_deposit'
            short = ts <= 1;            
            zs_short = short .* ((1 ./ dfs - 1) ./ ts);
            zs_long = (~short) .* (dfs .^ (-1 ./ ts) - 1);
            zs = zs_short + zs_long;
    end
end