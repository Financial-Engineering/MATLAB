% Bootstrap the zero rates for the swap contracts - Interpolate all interim
% dfs between the known dfs and the unknown one which is what we are trying
% to solve for
%
% Assumptions : (1) - the df of the first coupon date for every contract is
% known (either previously bootstrapped or by interpolation)
function [zero_rates, point_dfs, point_dates] = calcSWAPZeroRate2(swap_contracts, dcc, bdc, value_date, curve, curve_config)
    curve_swap_start_index = size(curve,1) + 1;
    t = cell2mat(swap_contracts(:,1)); % contract term
    tb = cell2mat(swap_contracts(:,2)); % contract term base
    nc = size(swap_contracts, 1); % number of swap contracts
    value_dates(1:nc) = value_date;
    value_dates = value_dates';    
    %end_dates = calcEndDates(value_dates, t, tb, 'ACT/365', bdc); % calc contract end dates vector
    end_dates = calcEndDates(value_dates + 2, t, tb, 'ACT/365', bdc); % temp only
    for i=1:nc % for each swap contract
        curve_swap_contract_start_index = size(curve,1) + 1;
        swap_rate_at_maturity = swap_contracts{i,5};
        %dates = genCashflowDates(value_date, end_dates(i), swap_contracts{i,3}, swap_contracts{i,4}, dcc, bdc);
        dates = genCashflowDates(value_date + 2, end_dates(i), swap_contracts{i,3}, swap_contracts{i,4}, dcc, bdc);
        dfs = getDFsFromCurve(curve, value_date, dates, 'linearDf', 'none'); % get all known dfs
        dates_down = shift(dates, 'down', value_date); % shift down
        dcfs = findDaysFraction(dates_down, dates, dcc);
        fi = findIndexOfValue(NaN, dfs', 'first'); % find the first index with unknown df - assumption (1)
        if (fi == 0)
            fi = 2; % if all dfs are already bootstrapped by other contracts (overlap), bootstrap this one assuming only the first df exists
        end

        % root solver
        [lb ub] = calcBounds(dfs, dcfs, fi, swap_rate_at_maturity); % fzero converges faster if bound is given
        f = @(x)function_f(x, dates, dfs, dcfs, fi, swap_rate_at_maturity);
        
        % for testing only - low and up should have opposite signs
        % low = function_f(lb, dates, dfs, dcfs, fi, swap_rate_at_maturity);
        % up = function_f(ub, dates, dfs, dcfs, fi, swap_rate_at_maturity);
        
        [root, fval, exitflag] = fzero(f,(lb+ub)/2); % Brent's method - with initial guess instead of bounds
        
        % for testing only - should be zero
        % zr = function_f(root, dates, dfs, dcfs, fi, swap_rate_at_maturity);
        
        if (exitflag ~= 1) % no root is found
            error ('root solver failed');
        end         
        
        % temp write to the curve for bootstrapping all swap contracts -
        % curve in calling function is not modified
        curve_swap_end_contract_index = curve_swap_contract_start_index + length(dates(fi:end)) - 1;
        curve(curve_swap_contract_start_index : curve_swap_end_contract_index, 1) = num2cell(dates(fi:end)); % dates
        curve(curve_swap_contract_start_index : curve_swap_end_contract_index, 4) = num2cell(calcIntermediateDFs(dfs(fi-1), dates, fi, root)); % dfs
        curve = cell_unique(curve, 1, 'first'); % retain unique tenors and the first one is chosen if duplicates exist
    end
    
    % convert all dfs to zero rates in one go    
    point_dates = cell2mat(curve(curve_swap_start_index:end, 1));
    ts = findDaysFraction(value_date, point_dates, dcc);
    point_dfs = cell2mat(curve(curve_swap_start_index:end, 4));
    zero_rates = num2cell(dfs_to_zeros(point_dfs, ts));
    point_dfs = num2cell(point_dfs);
    point_dates = num2cell(point_dates);
    
end

function [lb ub] = calcBounds(dfs, dcfs, first_unknown_index, swap_rate_at_maturity)
    j = first_unknown_index - 1;
    numerator = 1 - swap_rate_at_maturity * (dcfs(1:j) * dfs(1:j)' - dfs(j) * sum(dcfs(j+1:end-1)));
    denominator = 1 + swap_rate_at_maturity * dcfs(end);
    lb = numerator / denominator;
    clear numerator denominator;
    numerator = 1 - swap_rate_at_maturity * dcfs(1:j) * dfs(1:j)';
    denominator = 1 + swap_rate_at_maturity * sum(dcfs(j+1:end));
    ub = numerator / denominator;
end

% Implement equation (5) in RBC's spec to solve for the unknown df (i.e. input x)
function [fx] = function_f(x, dates, dfs, dcfs, first_unknown_index, swap_rate_at_maturity)
    j = first_unknown_index - 1;
    fx = dcfs(1:j) * dfs(1:j)'; % term1
    term2 = dcfs(j+1:end) .* dfs(j).^((dates(end) - dates(j+1:end)) / (dates(end) - dates(j))) * (x.^((dates(j+1:end) - dates(j)) / (dates(end) - dates(j))))';    
    fx = swap_rate_at_maturity * (fx + term2);
    fx = fx + x - 1; % term3 and the rhs term
end

% Calculate all dfs (include the two end ones) between the last known df and the newly solved root (df
% at maturity of a swap contract) - loglinear inerpolation on dfs
function [dfs] = calcIntermediateDFs(last_known_df, dates, first_unknown_index, calculated_df)
    j = first_unknown_index - 1;
    dfs = last_known_df .^ ((dates(end) - dates(j+1:end)) / (dates(end) - dates(j))) .* calculated_df .^ ((dates(j+1:end) - dates(j)) / (dates(end) - dates(j)));
end