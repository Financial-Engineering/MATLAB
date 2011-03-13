function [curve] = constructFXYieldSpreadCurve(dom_yield_curve, for_yield_curve, fwd_points, spot_rate, value_date, spot_date, dcc)
    curve(:,1) = fwd_points(:,1);
    fp_dates = cell2mat(fwd_points(:,1));
    observed_fwd_rates = spot_rate + cell2mat(fwd_points(:,2));
    % <-----> df1
    % <---------------------> df
    %        <--------------> df2
    dom_dfs = getDFsFromCurve(dom_yield_curve, value_date, fp_dates, 'loglinearDf'); % from value->settlement
    dom_df1 = getDFsFromCurve(dom_yield_curve, value_date, spot_date, 'loglinearDf'); % from value->spot
    dom_dfs2 = dom_dfs ./ dom_df1; % from spot->settlement
    for_dfs = getDFsFromCurve(for_yield_curve, value_date, fp_dates, 'loglinearDf');
    for_df1 = getDFsFromCurve(for_yield_curve, value_date, spot_date, 'loglinearDf');
    for_dfs2 = for_dfs ./ for_df1;
    implied_for_dfs2 = observed_fwd_rates .* dom_dfs2 / spot_rate;
    ts = findDaysFraction(spot_date, fp_dates, dcc);
    implied_for_zs = dfs_to_zeros(implied_for_dfs2, ts, 'cont_compounded');
    for_zs = dfs_to_zeros(for_dfs2, ts, 'cont_compounded');
    curve(:,2) = num2cell(implied_for_zs - for_zs);
end