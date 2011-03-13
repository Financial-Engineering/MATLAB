% Bootstrap the zero rates for the money market contracts. The input from
% the contract is simple interest rate (=zero rate)
function [zero_rates, dfs, end_dates] = calcMMZeroRate2(mm_contracts, dcc, rc, today, curve, curve_config)
    num_of_contracts = size(mm_contracts, 1);
    t = cell2mat(mm_contracts(:,1)); % contract term
    tb = cell2mat(mm_contracts(:,2)); % contract term base    
    days_offsets = zeros(1, num_of_contracts);
    if (size(mm_contracts,2) > 3)
        for i=1:num_of_contracts
            if (~isempty(mm_contracts{i,4}))
                days_offsets(i) = cell2mat(mm_contracts(i,4)); % rates applied from date which is offset from value_date by this number of days (spot)
            end
        end        
    end
    nc = size(mm_contracts, 1); % number of mm contracts
    rate_dates(1:nc) = today + days_offsets;
    rate_dates = rate_dates';
    end_dates = calcEndDates(rate_dates, t, tb, 'ACT/365', rc); % calc contract end dates vector
    ds = (end_dates - rate_dates) / calcDaysInYear(today, dcc); % real contract duration in years
    zs = cell2mat(mm_contracts(:,3)); % annualised simple rates
    df2s = zeros_to_dfs(zs, ds); % calc (forward) discount factors from zero rates
    
    dfs = df2s;
    for i=1:num_of_contracts % calc per contract - since need to take into account spot date
        % temp for calc df1s only        
        curve = num2cell(zeros(num_of_contracts, 4));
        curve(:,1) = num2cell(end_dates);
        curve(:,4) = num2cell(dfs);
        % calc (bootstrap) each discount factor
        df1s = getDFsFromCurve(curve, today, rate_dates, 'loglinearDf', 'none'); % get all known dfs
        dfs = df1s .* df2s;
    end
    
    ts = (end_dates - today) / calcDaysInYear(today, dcc);
    zero_rates = num2cell(dfs_to_zeros(dfs, ts));
    dfs = num2cell(dfs);
    end_dates = num2cell(end_dates);    
end