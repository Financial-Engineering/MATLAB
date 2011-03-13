% convert long input vectors into matrices, each column represents one calc
% period. All input vectos are from Razor's cashflows so should be all of equal
% size
r=1; c=1;
for i=1:length(df_vector)   
   rates(r,c) = rates_vector(i);
   day_diff_day_rates(r,c) = day_diff_day_rates_vector(i);
   calc_period_start_dates(r,c) = calc_period_start_dates_vector(i);
   calc_period_end_dates(r,c) = calc_period_end_dates_vector(i);
   r=r+1;
   if (df_vector(i) > 0.0)
       df(c) = df_vector(i);
       razor_average_rates(c) = razor_average_rates_vector(i);
       razor_pv_interests(c) = abs(razor_pv_interests_vector(i));
       c=c+1;
       r=1;
   end
end

% rate_start_dates and rate_end_dates are n x m matrices with each column contains the start and end calendar dates of each (business) fixing rate 
%%%% Uncomment out the following line for validation against spreadsheet, and comment out for Razor vetting
% day_diff_day_rates = rate_end_dates - rate_start_dates; %!!!!!!!!!!!!!!
% calc_period_start_dates and calc_period_end_dates are of the same
% dimension as rates and each element corresponds to the calc start and end
% date for the corresponding element in rates. So calc_period_start_dates and
% calc_period_end_dates contain n identical rows
day_diff_cal_periods = calc_period_end_dates - calc_period_start_dates;
unique_day_diff_cal_periods = max(day_diff_cal_periods); % get unique cal period durations

% un-weighted average
% rates are n x m matrix with each column storing the (business) fixing
% rates for each calc period. For empty rates zeros are padded, so have to
% ignore all zeros in average calc
n=max(sum(rates~=0,1),1);
unweighted_average_rates = sum((rates+spread),1)./n; % unweighted_average_rates is a 1 x m vector containing all the average rates for each calc period
% df contains the discount factors for each calc period, and zero if the
% calc period is prior to the value date
pv_interest_unweighted = N * unweighted_average_rates .* unique_day_diff_cal_periods .* df / 365;

% weighted average
day_diff_cal_periods(find(day_diff_cal_periods == 0)) = -1; % replacing all zeros by -1 to avoid NaN
w = day_diff_day_rates ./ day_diff_cal_periods;
w = w';
%w = round(w * 1e8) / 1e8; % round to 8dp to match RBC's spreadsheet
weighted_average_rates = (w * (rates* rate_multiplier+spread)) ;
weighted_average_rates = diag(weighted_average_rates);
pv_interest_weighted = N * weighted_average_rates' .* unique_day_diff_cal_periods .* df / 365;

% compare Matlab's and Razor's results
razor_average_rates = razor_average_rates';
average_rate_errors = weighted_average_rates - razor_average_rates;
pv_interest_weighted_errors = pv_interest_weighted - razor_pv_interests;
number_of_unmatching_rates = 0;
number_of_unmatching_pvs = 0;
for i=1:length(razor_average_rates)
    if (razor_average_rates(i) >= 0.1)
        if (abs(average_rate_errors(i)) >= 0.00000001)
            number_of_unmatching_rates = number_of_unmatching_rates + 1;
        end
    elseif (razor_average_rates(i) >= 0.01)
        if (abs(average_rate_errors(i)) >= 0.000000001)
            number_of_unmatching_rates = number_of_unmatching_rates + 1;
        end
    elseif (razor_average_rates(i) >= 0.001)
        if (abs(average_rate_errors(i)) >= 0.0000000001)
            number_of_unmatching_rates = number_of_unmatching_rates + 1;
        end
    elseif (razor_average_rates(i) >= 0.0001)
        if (abs(average_rate_errors(i)) >= 0.00000000001)
            number_of_unmatching_rates = number_of_unmatching_rates + 1;
        end        
    end    
end
number_of_unmatching_rates
