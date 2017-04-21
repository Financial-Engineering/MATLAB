% Zero spread curve stores {curve_tenors, zero_spreads}
function [curve] = constructBasisSwapZeroSpreadCurveMM(swaps_tenors, benchmark_yield_curve, market_spreads, value_date, spot_lag, dcc, bdc, calendars)
    % construct/convert inputs
    ref_freq_term = swaps_tenors{1,1};
    ref_freq_base = swaps_tenors{1,2};
    nonref_freq_term = swaps_tenors{2,1};
    nonref_freq_base = swaps_tenors{2,2};
    maturities_term = cell2mat(market_spreads(:,1));
    maturities_base = cell2mat(market_spreads(:,2));
    spreads = cell2mat(market_spreads(:,3));
    nc = size(market_spreads,1);    
    spot_date = calcSpotDates(value_date, spot_lag, calendars); % calc spot date based on spot lag and holidays from merged calendars
    start_dates = spot_date .* ones(nc,1); % col vector of start date
    
    % initialise outputs
    curve(:,1) = num2cell(calcEndDates(start_dates, maturities_term, maturities_base, dcc, bdc, calendars)); % calc curve tenors    
    
    % bootstrap each tenor for zero spread curve from each market quoted
    % fair spread
    mp = 0; % mp is the index of the cf on ref side corresponding to the last solved tenor/cf on the nonref side
    j = 0; % 
    for i=1:nc
        % gencashflows
        ref_cfs_dates = genCashflowDates(spot_date, curve{i,1}, ref_freq_term, ref_freq_base, dcc, bdc, calendars); % cashflows on the ref side
        nonref_cfs_dates = genCashflowDates(spot_date, curve{i,1}, nonref_freq_term, nonref_freq_base, dcc, bdc, calendars); % cashflows on the non-ref side
        ref_reset_dates = ref_cfs_dates; % set reset dates to accrual dates for now, need to implement full floating side cashflows later!!!!!
        nonref_reset_dates = nonref_cfs_dates;
        %%
        % <latex>
        % $\sum^m_{i=m_p+1}\tau_i r_{i-1 \rightarrow i} df_i$
        % </latex>
        m = length(ref_cfs_dates);
        ref_cfs_dates_down = shift(ref_cfs_dates, 'down', spot_date); % shift down
        ref_taus = findDaysFraction(ref_cfs_dates_down, ref_cfs_dates, dcc);
        clear fwd_dates;
        fwd_dates(1) = spot_date;
        fwd_dates(2:length(ref_reset_dates)+1) = ref_reset_dates;
        ref_fwd_rates = getFwdRatesFromCurve(benchmark_yield_curve, value_date, fwd_dates, dcc);
        ref_dfs = getDFsFromCurve(benchmark_yield_curve, value_date, ref_cfs_dates);
        numerator = ref_taus(mp+1:m) .* ref_fwd_rates(mp+1:m) * ref_dfs(mp+1:m)';
        %%
        % <latex>
        % $\sum^n_{k=j+1} \frac{\hat\tau_k}{\hat\tau_k^I} df_k$
        % </latex>
        n = length(nonref_cfs_dates);
        nonref_cfs_dates_down = shift(nonref_cfs_dates, 'down', spot_date); % shift down
        nonref_taus = findDaysFraction(nonref_cfs_dates_down, nonref_cfs_dates, dcc);
        nonref_reset_dates_down = shift(nonref_reset_dates, 'down', spot_date); % shift down
        nonref_taus_I = findDaysFraction(nonref_reset_dates_down, nonref_reset_dates, dcc);
        nonref_dfs = getDFsFromCurve(benchmark_yield_curve, value_date, nonref_cfs_dates);
        numerator = numerator + nonref_taus(j+1:n) ./ nonref_taus_I(j+1:n) * nonref_dfs(j+1:n)';
        %%
        % <latex>
        % $(\delta_{p,n} - \delta_n) \sum^j_{k=1} \hat\tau_k df_k$
        % </latex>
        if ((j > 0) && (i > 1))
            numerator = numerator + (spreads(i-1) - spreads(i)) * nonref_taus(1:j) * nonref_dfs(1:j)';
        end
        %%
        % <latex>
        % $\delta \sum^n_{k=j+1} \hat\tau_k df_k$
        % </latex>        
        numerator = numerator - spreads(i) * nonref_taus(j+1:n) * nonref_dfs(j+1:n)';
        %%
        % <latex>
        % $\sum^n_{k=j+1} \frac{\hat\tau_k df_{k-1}^I df_k}{\hat\tau_k^I df_k^I}$
        % </latex>
        nonref_dfs_I = getDFsFromCurve(benchmark_yield_curve, value_date, nonref_reset_dates);
        if (j > 0)
            denominator = nonref_taus(j+1:n) ./ nonref_taus_I(j+1:n) .* (nonref_dfs_I(j:n-1) ./ nonref_dfs_I(j+1:n)) * nonref_dfs(j+1:n)';
        else
            initial_nonref_df_I = getDFsFromCurve(benchmark_yield_curve, value_date, spot_date);
            denominator = nonref_taus(j+1:n) ./ nonref_taus_I(j+1:n) .* (initial_nonref_df_I ./ nonref_dfs_I(j+1:n)) * nonref_dfs(j+1:n);
        end
        % solve for Q_k
        Q_j_plus_1 = numerator / denominator;
        
        % solve for y
        taus = findDaysFraction(value_date, nonref_reset_dates, dcc);
        if (i > 1)
            curve{i,2} = log(Q_j_plus_1^(n-j) / exp(-curve{i-1,2} * taus(j))) / taus(n); % assume here that length of nonref_reset_dates = nonref_cf_dates
        else
            %curve{i,2} = log(Q_j_plus_1^(n-j)) / taus(n);
            clear numerator;
            tau_spot = findDaysFraction(value_date, spot_date, dcc);
            numerator = exp(-log(Q_j_plus_1^(n-j)) * tau_spot / (taus(n) - tau_spot));
            curve{i,2} = log(Q_j_plus_1^(n-j) / numerator) / taus(n);
        end
        
        % update mp and j
        mp = m;
        j = n;
        
    end
    
end