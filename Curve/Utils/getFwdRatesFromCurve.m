% Calculate the fwd_rates of each adjacent pair of fwd_dates. So the first
% fwd_rate corresponds to the fwd_rate of period
% (fwd_dates(1),fwd_dates(2)), and so on.
function [fwd_rates] = getFwdRatesFromCurve(curve, today, fwd_dates, dcc)
    initial_reset_date = fwd_dates(1);
    fds = fwd_dates(2:end); % fwd_rates has same dimension as fds
    fds_down = shift(fds, 'down', initial_reset_date);
    taus = findDaysFraction(fds_down, fds, dcc);
    dfs = getDFsFromCurve(curve, today, fds,'loglinearDf');
    initial_df = getDFsFromCurve(curve, today, initial_reset_date,'loglinearDf');
    dfs_down = shift(dfs, 'down', initial_df);
    dfs_ratios = dfs_down ./ dfs;
    fwd_rates = (dfs_ratios - 1) ./ taus;
end