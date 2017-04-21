function [zero_rates, dfs, end_dates] = calcEUROFUTZeroRate(fut_contracts, dcc, rc, today, curve)
    num_of_futures = size(fut_contracts,1);
    dfs = zeros(1, num_of_futures);
    zero_rates = zeros(1, num_of_futures);
    start_dates = cell2mat(fut_contracts(:,1));
    end_dates = cell2mat(fut_contracts(:,2));
    ds = (end_dates - start_dates) / calcDaysInYear(today, dcc);
    d2 = (end_dates - today) / calcDaysInYear(today, dcc);
    p = cell2mat(fut_contracts(:,3)); % price
    fut = 1 - p / 100; % futures rates on quarterly compounding
    fut = (365/90) * log(fut ./ 4 + 1);
    t1 = (start_dates - today) / calcDaysInYear(today, dcc);
    t2 = d2;
    %sigma = calcCapImpliedVol(cap_price);
    sigma = 0.012;
    %convexity_adjustment = 0.5 * sigma * sigma * t1 .* t2;
    %fwd = fut - convexity_adjustment; % adjusted forward rates
    fwd = fut;
    for i=1:num_of_futures
        dfs1 = getDFsFromCurve(curve, today, start_dates(i)); % assume exists from previous contract types
        dfs2 = dfs1 / (1 + fwd(i) * ds(i));
        dfs(i) = dfs2;
        zero_rates(i) = dfs_to_zeros(dfs2, d2(i));
    end
    dfs = num2cell(dfs);
    zero_rates = num2cell(zero_rates);
    end_dates = num2cell(end_dates);
end