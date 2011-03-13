function [yield_curve yield_curve_config] = bootstrap(contracts_config, contracts, curve_config)
    % curve is the yield curve. It is an array of termstructures bootstraped by
    % different securities. Each element in the array stores {contract
    % maturity date, contract type, zero rate, discount factor}
    index = 1;    
    curve = num2cell(zeros(1)); % dummy init
    value_date = curve_config{1}; % value_date
    for i=1:length(contracts_config)
        nc = contracts_config{i}{2}; % number of contracts
        dcc = contracts_config{i}{4};
        [zero_rates, dfs, dates] = contracts_config{i}{3}(contracts(index:index+nc-1,:), dcc, contracts_config{i}{5}, value_date, curve, curve_config); % calc zero rates, dfs & maturity and all cashflow dates
        n_tenors = length(dates); % number of tenors returned from bootstrapping this contract type (include all cfs for swaps)        
        curve(index:index+n_tenors-1,3) = zero_rates;
        curve(index:index+n_tenors-1,4) = dfs;
        curve(index:index+n_tenors-1,1) = dates;
        curve(index:index+n_tenors-1,2) = contracts_config{i}(1); % contract type
        index = index + n_tenors;
    end
    yield_curve = cell_unique(curve, 1, 'first'); % retain unique tenors and the first one is chosen if duplicates exist
    yield_curve_config = curve_config;
end