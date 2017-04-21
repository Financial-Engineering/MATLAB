% Get yield spreads (may need to interpolate or extrapolate) from yield
% spread curve for the given set of fwd_dates
function [yss] = getYieldsFromSpreadCurve(curve, fwd_dates)
    ins = (fwd_dates >= curve{1,1}) & (fwd_dates <= curve{end,1}); % interpolate
    ins_fwd_dates1 = ins .* fwd_dates;
    ins_fwd_dates2 = curve{end,1} * ~ins;
    ins_fwd_dates = ins_fwd_dates1 + ins_fwd_dates2; % replace all dates outside the curve date range to be the end date of the curve to avoid NaN during interpolation
    outs = (fwd_dates < curve{1,1}) | (fwd_dates > curve{end,1}); % extrapolate
    outs_fwd_dates = outs .* fwd_dates;
    curve_point_dates = cell2mat(curve(1:size(curve,1),1)); % extract all point (bootstrapped) dates - x
    curve_yss = cell2mat(curve(1:size(curve,1),2)); % extract all spreads - y
    if (max(outs) > 0) % some dates need extrapolation
        % Extrapolate
        outs_short = outs_fwd_dates < curve{1,1};
        outs_long = outs_fwd_dates > curve{end,1};        
        % 'Flat'
        outs_yss_short = curve_yss(1) * outs_short .* ones(size(outs_fwd_dates));
        outs_yss_long = curve_yss(end) * outs_long .* ones(size(outs_fwd_dates));
        outs_yss = outs_yss_short + outs_yss_long;
        % 'linear'
        %outs_yss = interp1(curve_point_dates, curve_yss, outs_fwd_dates, 'linear', 'extrap'); % given x, y, fwd_dates (xi), extrapolate (linearly) yi (yss)
        outs_yss = outs_yss .* outs;
    end
    if (max(ins) > 0) % some dates need interpolation
        % Interpolate
        ins_yss = interp1(curve_point_dates, curve_yss, ins_fwd_dates); % given x, y, fwd_dates (xi), interpolate (linearly) yi (yss)
        ins_yss = ins_yss .* ins;
    end
    e = 0;
    if (exist('ins_yss'))
        e = e + 1;
    end    
    if (exist('outs_yss'))
        e = e + 2;
    end
    if (e == 1)
        yss = ins_yss;
    elseif (e == 2)
        yss = outs_yss;
    else % both ins_dfs & outs_dfs exist
        yss = ins_yss + outs_yss; % merge the two
    end        
end