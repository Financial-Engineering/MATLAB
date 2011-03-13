% Bootstrap the zero rates for the swap contracts - Interpolate all interim
% swap rates and solve each df iteratively
function [zero_rates, point_dfs, point_dates] = calcSWAPZeroRate1(swap_contracts, dcc, bdc, today, curve, curve_config)
    curve_swap_start_index = size(curve,1) + 1;
    dfs = zeros(size(swap_contracts,1),1); % dfs for each curve_end_dates
    srs = zeros(size(swap_contracts,1),1); % swap rates for each curve_end_dates
    curve_end_dates = zeros(size(swap_contracts,1),1); % last bootstrapped date for each contract
    t = cell2mat(swap_contracts(:,1)); % contract term
    tb = cell2mat(swap_contracts(:,2)); % contract term base
    nc = size(swap_contracts, 1); % number of swap contracts
    todays(1:nc) = today;
    todays = todays';
    end_dates = calcEndDates(todays, t, tb, 'ACT/365', bdc); % calc contract end dates vector
    for i=1:nc % for each swap contract                
        if (i > 1) % search for swap rate from last contract with the same term, if exists, and pass it to genBootstrapCashFlows
            pn = num2str(cell2mat(swap_contracts(1:i-1,3)));
            past_contract_terms = strcat(pn, swap_contracts(1:i-1,4));
            tn = num2str(cell2mat(swap_contracts(i,3)));
            this_contract_term = strcat(tn, swap_contracts(i,4));
            li = findIndexOfValue(this_contract_term, past_contract_terms, 'last');
            %j = [1:i-1];
            %m = ismember(past_contract_terms, this_contract_term);
            %li = max(j .* m);       
            if (li > 0) % found                
                cfs = genBootstrapCashFlows(today, end_dates(i), swap_contracts{i,3}, swap_contracts{i,4}, dcc, bdc, swap_contracts{i,5}, curve, srs(li), curve_end_dates(li));
            else % no previous contract with same term exists
                cfs = genBootstrapCashFlows(today, end_dates(i), swap_contracts{i,3}, swap_contracts{i,4}, dcc, bdc, swap_contracts{i,5}, curve); 
            end
        else
            cfs = genBootstrapCashFlows(today, end_dates(i), swap_contracts{i,3}, swap_contracts{i,4}, dcc, bdc, swap_contracts{i,5}, curve);
        end
        % temp write to the curve for bootstrapping all swap contracts -
        % curve in calling function is not modified
        clear e;
        e = size(curve,1)+1;
        %curve(e,1) = cfs(end,1); % date
        %curve(e,4) = cfs(end,3); % df
        curve_swap_end_index = curve_swap_start_index + size(cfs,1) - 1;
        curve(curve_swap_start_index : curve_swap_end_index, 1) = cfs(:,1); % date
        curve(curve_swap_start_index : curve_swap_end_index,4) = cfs(:,3); % df        
        curve = cell_unique(curve, 1, 'first'); % retain unique tenors and the first one is chosen if duplicates exist        
        curve_end_dates(i) = cell2mat(cfs(end,1)); % last bootstrapped date in each contract cfs
        dfs(i) = cell2mat(cfs(end,3)); % last df in each contract cfs
        srs(i) = cell2mat(cfs(end,2)); % last swap rate (implied, interpolated or quoted) in each contract cfs
    end
    
    % convert all dfs to zero rates in one go    
    %ts = findDaysFraction(today, end_dates, dcc);
    %zero_rates = num2cell(dfs_to_zeros(dfs, ts));
    %dfs = num2cell(dfs);
    %end_dates = num2cell(end_dates);
    point_dates = cell2mat(cfs(:,1)); % all cashflow dates of this swap contract
    ts = findDaysFraction(today, point_dates, dcc);
    point_dfs = cell2mat(cfs(:,3));
    zero_rates = num2cell(dfs_to_zeros(point_dfs, ts));
    point_dfs = num2cell(point_dfs);
    point_dates = num2cell(point_dates);
    
end

% Generate cashflows for bootstraping starting from start_date and ends at end_date, with
% frequency = frequency_term++frequency_base (e.g. 3M), using day count
% convention dcc and business day roll convention bdc
% Cashflows format {date, swap rate, df} - swap rate here is the swap rate
% used to calculate the df
function [cfs] = genBootstrapCashFlows(start_date, end_date, frequency_term, frequency_base, dcc, bdc, swap_rate_at_maturity, curve, last_swap_rate, last_contract_maturity_date)
    % gen dates first, according to dcc and bdc
    i=1;
    date = start_date;   
    while (date < end_date)
        %date = calcEndDates(start_date, i * frequency_term, frequency_base, dcc, bdc);
        date = calcEndDates(start_date, i * frequency_term, frequency_base, 'ACT/365', bdc); % always actual when calculating maturity dates
        if (date <= end_date)
            cfs{i,1} = date;
            if (date == end_date)
                cfs{i,2} = swap_rate_at_maturity;
            end 
        end
        i = i + 1;
    end
    
    % get all possible dfs (directly bootstrapped or interpolated from existing ones) from curve    
    cfs(:,3) = num2cell(getDFsFromCurve(curve, start_date, cell2mat(cfs(:,1)), 'linearDf', 'none'));
    %cfs(:,3) = num2cell(getDFsFromCurve(curve, cell2mat(cfs(:,1))));
    
    % calc all swaps rates possible, either by interpolation or finding the
    % effect swap rate from previously known dfs (either point or
    % interpolated dfs from this or other type of contract)
    fi = findIndexOfValue(NaN, cell2mat(cfs(:,3)), 'first'); % find the first index of cashflow with an unknown df
    if (nargin == 10) % last_swap_rate exists, so just set up data points for interpolation   
        x = [last_contract_maturity_date, end_date];
        y = [last_swap_rate, swap_rate_at_maturity];              
    else % need to calc effective swap rate first
        % find effect swap rate of the one before the first cashflow with
        % unknown df (i.e. fi-1)
        efi = fi - 1; % cashflow index for derived effective swap rate from all known dfs
        dcfs = cell2mat(cfs(1:efi,1));
        dcfs1(1) = start_date;
        dcfs1(2:efi) = dcfs(1:efi-1);
        dcfs1 = dcfs1';
        dcfs = findDaysFraction(dcfs1, dcfs, dcc);
        dfs = cell2mat(cfs(1:efi,3));
        product = dcfs' * dfs;
        cfs{efi,2} = (1 - cfs{efi,3}) / product; % effective swap rate for last term date
        x = [cfs{efi,1}, end_date];
        y = [cfs{efi,2}, swap_rate_at_maturity];
    end
    
    % now derive all dfs one by one - assume that fi <> 1, which means at
    % least one df in the term of this swap contract is known already. For
    % swap contract with no previous contracts with the same term, fi > 2.
    %clear dcfs; clear dcfs1;    
    l_cfs = size(cfs,1);
    for i=fi:l_cfs        
        % set up data points for interpolation
        if (l_cfs > fi)
            if (i > fi)
                x = [cfs{i-1,1}, end_date];
                y = [cfs{i-1,2}, swap_rate_at_maturity];
            end
            xi = cfs{i,1};
            cfs{i,2} = interp1(x,y,xi); % interpolate the swap rate
        end
        
        % calc df based on the swap rate and all previous dfs
        clear dcfs; clear dcfs1; clear dfs; clear product;
        dcfs = cell2mat(cfs(1:i-1,1));
        dcfs1(1) = start_date;
        dcfs1(2:i-1) = dcfs(1:i-2);
        dcfs1 = dcfs1';
        dcfs = findDaysFraction(dcfs1, dcfs, dcc);
        dfs = cell2mat(cfs(1:i-1,3));
        product = dcfs' * dfs;
        cfs{i,3} = (1 - cfs{i,2} * product) / (1 + cfs{i,2} * findDaysFraction(cfs{i-1,1}, cfs{i,1}, dcc)); % df for this term date
    end
        
end