function [dfs] = zeros_to_dfs(zs, ts, zero_treatment, freq)
    if (nargin < 3)
        zero_treatment = 'simple'; % default
    end
    switch zero_treatment
        case 'simple'            
            dfs = 1 ./ (1 + zs .* ts);
        case 'compounded'
            if (nargin < 4)
                freq = 1; % default to annual-compounding
            end
            dfs = (1 + zs / freq) .^ (-freq * ts);
        case 'cont_compounded'
            dfs = exp(-zs .* ts);
        case 'cash_deposit'
            short = ts <= 1;
            dfs_short = short .* (1 ./ (1 + zs .* ts));
            dfs_long = (~short) .* ((1 + zs) .^ (-ts));
            dfs = dfs_short + dfs_long;
    end
end