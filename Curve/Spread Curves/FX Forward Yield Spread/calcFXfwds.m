% Calculate the FX fwd rates from the fwd market. varargin contains {for_yield_curve, yields_spread_curve} for method 2 and
% {fwd_pts} for method 1. The difference between the 2 methods is that
% method 2 may need to interpolate / extrapolate the yield spread curve,
% whereas method 1 may need to interpolate / extrapolate the fwd pts curve.
% When the foreign swap yield curve is present should always use method 2.
function [FX_fwds] = calcFXfwds(dom_yield_curve, spot_rate, value_date, spot_date, fwd_dates, dcc, varargin)
    % <-----> df1
    % <---------------------> df
    %        <--------------> df2
    dom_dfs = getDFsFromCurve(dom_yield_curve, value_date, fwd_dates, 'loglinearDf');  % from value->settlement
    dom_df1 = getDFsFromCurve(dom_yield_curve, value_date, spot_date, 'loglinearDf'); % from value->spot
    dom_dfs2 = dom_dfs ./ dom_df1; % from spot->settlement
    if (size(varargin,2) > 1)
        % use yield spread curve - method 2
        for_yield_curve = varargin{1};
        yields_spread_curve = varargin{2};
        for_dfs = getDFsFromCurve(for_yield_curve, value_date, fwd_dates, 'loglinearDf');
        for_df1 = getDFsFromCurve(for_yield_curve, value_date, spot_date, 'loglinearDf');
        for_dfs2 = for_dfs ./ for_df1;
        yss = getYieldsFromSpreadCurve(yields_spread_curve, fwd_dates);
        ts = findDaysFraction(spot_date, fwd_dates, dcc);
        FX_fwds = spot_rate * for_dfs2 .* exp(-yss .* ts) ./ dom_dfs2;
    elseif  (size(varargin,2) == 1)
        % foreign swap yield curve missing - method 1
        fwd_pts = varargin{1};
        fps = getFwdPts(fwd_pts, fwd_dates);
        observed_fwd_rates = spot_rate + fps;
        %implied_for_dfs = observed_fwd_rates .* dom_dfs / spot_rate;
        %FX_fwds = spot_rate * implied_for_dfs ./ dom_dfs;
        FX_fwds = observed_fwd_rates; % it's the same as the last 2 lines
    else
        error('Wrong number of inputs');
    end
end