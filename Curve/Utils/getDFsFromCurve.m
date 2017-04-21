% Get all possible discount factors from curve specified by the end_dates.
% If interp_method and interp_domain are missing and needed, linear DF is assumed. If
% extrap_method and extrap_domain are missing and needed, last (flat) DF is assumed.
% If zero_treatment is missing and needed (anything to do with zeros),
% simple zero is assumed. interp_method = {'linearDf', 'loglinerDf',
% 'linearZero', 'loglinearZero'}, extrap_method = {'lastDf', 'linearDf',
% 'lastZero', 'linearZero', 'none'}, zero_treatment = {'simple',
% 'compounded', 'cont_compounded', 'cash_deposit'}. If extrapolation method
% is set to 'none' then extrapolation is not performed. If there are date points outside the curve range, NaN
% will return (from interpolation).

function [dfs] = getDFsFromCurve(curve, today, end_dates, interp_method, extrap_method, zero_treatment, freq, curve_dcc) 
    ins = (end_dates >= curve{1,1}) & (end_dates <= curve{end,1}); % interpolate
    ins_end_dates1 = ins .* end_dates;
    ins_end_dates2 = curve{end,1} * ~ins;
    ins_end_dates = ins_end_dates1 + ins_end_dates2; % replace all dates outside the curve date range to be the end date of the curve to avoid NaN during interpolation
    outs = (end_dates < curve{1,1}) | (end_dates > curve{end,1}); % extrapolate
    outs_end_dates = outs .* end_dates;
    if (nargin < 7)
        freq = 1; % default is annual-compounding
    end    
    if ((nargin > 4) && (strcmp(extrap_method, 'none')))
        no_outs = 1;
    else
        no_outs = 0;
    end
    curve_point_dates = cell2mat(curve(1:size(curve,1),1)); % extract all point (bootstrapped) dates - x
    todays = today * ones(size(end_dates));
    if (nargin < 8)
        curve_dcc = 'ACT/360'; % default
    end
    ts = findDaysFraction(todays, end_dates, curve_dcc);
    curve_dates = cell2mat(curve(1:size(curve,1),1)); % extract all curve dates
    todays = today * ones(1,length(curve_dates));
    ds = findDaysFraction(todays', curve_dates, curve_dcc);
    curve_dfs = cell2mat(curve(1:size(curve,1),4)); % extract all dfs - y
    curve_zeros = cell2mat(curve(1:size(curve,1),3)); % extract all zero rates - y
    if (max(outs) > 0) % some dates need extrapolation
        if (~no_outs) % extrapolation enabled
            % Extrapolate        
            outs_short = outs_end_dates < curve{1,1};
            outs_long = outs_end_dates > curve{end,1};        
            if ((nargin <= 4) || ((nargin >= 5) && strcmp(extrap_method, 'lastDf')))
                % lastDf - default
                outs_dfs_short = curve_dfs(1) * outs_short .* ones(size(outs_end_dates));
                outs_dfs_long = curve_dfs(end) * outs_long .* ones(size(outs_end_dates));
                outs_dfs = outs_dfs_short + outs_dfs_long;
            elseif ((nargin >= 5) && strcmp(extrap_method, 'linearDf'))
                % linearDf
                outs_dfs = interp1(curve_point_dates, curve_dfs, outs_end_dates, 'linear', 'extrap'); % given x, y, end_dates (xi), extrapolate (linearly) yi (dfs)
            elseif ((nargin >= 5) && (strcmp(extrap_method, 'lastZero') || strcmp(extrap_method, 'linearZero')))
                % lastZero or linearZero
                if ((nargin < 6) || ((nargin >= 6) && strcmp(zero_treatment, 'simple'))) % default is simple
                    curve_zs = curve_zeros;
                else
                    curve_zs = dfs_to_zeros(curve_dfs, ds, zero_treatment, freq);
                end
                if (strcmp(extrap_method, 'lastZero'))
                    % last zero
                    outs_zs_short = curve_zs(1) * outs_short .* ones(size(outs_end_dates));
                    outs_zs_long = curve_zs(end) * outs_long .* ones(size(outs_end_dates));
                    zs = outs_zs_short + outs_zs_long;
                else
                    % linear zero
                    zs = interp1(curve_point_dates, curve_zs, outs_end_dates, 'linear', 'extrap');
                end
                if ((nargin < 6) || ((nargin >= 6) && strcmp(zero_treatment, 'simple'))) % default is simple
                    outs_dfs = zeros_to_dfs(zs, ts);
                else
                    outs_dfs = zeros_to_dfs(zs, ts, zero_treatment, freq);
                end
            end
            outs_dfs(outs_end_dates <= today) = 1; % anything earlier than today should return 1
        else % extrapolation disabled
            outs_dfs = interp1(curve_point_dates, curve_dfs, end_dates); % generate NaN for extrap date points
        end
        outs_dfs = outs_dfs .* outs;
    end
    if (max(ins) > 0) % some dates need interpolation
        % Interpolate
        if ((nargin == 3) || ((nargin >= 4) && strcmp(interp_method, 'linearDf')))
            % linear df - default
            ins_dfs = interp1(curve_point_dates, curve_dfs, ins_end_dates); % given x, y, end_dates (xi), interpolate (linearly) yi (dfs)
        elseif ((nargin >= 4) && strcmp(interp_method, 'loglinearDf'))
            % loglinear df
            log_curve_dfs = log(curve_dfs);
            logdfs = interp1(curve_point_dates, log_curve_dfs, ins_end_dates);
            ins_dfs = exp(logdfs);
        elseif ((nargin >= 4) && ((strcmp(interp_method, 'linearZero')) || strcmp(interp_method, 'loglinearZero')))
            % linear zero or loglinear zero
            if ((nargin < 6) || ((nargin >= 6) && strcmp(zero_treatment, 'simple'))) % default is simple
                curve_zs = curve_zeros;
            else                
                if (nargin < 7)
                    freq = 1; % default is annual-compounding
                end
                curve_zs = dfs_to_zeros(curve_dfs, ts, zero_treatment, freq);
            end
            if (strcmp(interp_method, 'linearZero'))
                % linear zero
                zs = interp1(curve_point_dates, curve_zs, ins_end_dates); % given x, y, end_dates (xi), interpolate (linearly) yi (zs)                
            else
                % loglinear zero
                log_curve_zs = log(curve_zs);
                log_zs = interp1(curve_point_dates, log_curve_zs, ins_end_dates);
                zs = exp(log_zs);
            end
            ins_dfs = zeros_to_dfs(zs, ts);            
        end
        ins_dfs = ins_dfs .* ins;
    end
    e = 0;
    if (exist('ins_dfs'))
        e = e + 1;
    end    
    if (exist('outs_dfs'))
        e = e + 2;
    end
    if (e == 1)
        dfs = ins_dfs;
    elseif (e == 2)
        dfs = outs_dfs;
    else % both ins_dfs & outs_dfs exist
        dfs = ins_dfs + outs_dfs; % merge the two
    end
    dfs(end_dates == today) = 1;
end
