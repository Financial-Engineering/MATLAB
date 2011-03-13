% Bootstrap the zero rates for the money market contracts. The input from
% the contract is price
function [zero_rates, dfs, end_dates] = calcMMZeroRate(mm_contracts, dcc, rc, today, curve, curve_config)
    t = cell2mat(mm_contracts(:,1)); % contract term
    tb = cell2mat(mm_contracts(:,2)); % contract term base
    nc = size(mm_contracts, 1); % number of mm contracts
    todays(1:nc) = today;
    todays = todays';
    end_dates = calcEndDates(todays, t, tb, dcc, rc); % calc contract end dates vector
    ds = end_dates - today; % real contract duration in years
    ds = ds / calcDaysInYear(today, dcc);
    f = cell2mat(mm_contracts(:,3)); % face value
    p = cell2mat(mm_contracts(:,4)); % price
    zs = (f-p)./(ds .* p);
    zero_rates = num2cell(zs);
    end_dates = num2cell(end_dates);
    dfs = num2cell(zeros_to_dfs(zs, ds)); % calc discount factors from zero rates    
end