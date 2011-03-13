% rate_start_dates and rate_end_dates are n x m matrices with each column contains the start and end calendar dates of each (business) fixing rate 
day_diff_day_rates = rate_end_dates - rate_start_dates;
dcf_day_rates = (rate_end_dates - rate_start_dates) / 365;
% rates are n x m matrix with each column storing the (business) daily
% fixing OIS rates for each calc period
w = 1 + (rates + spread) .* dcf_day_rates; % element-by-element multiplication. w hence becomes a n x m matrix
% calc_period_start_dates and calc_period_end_dates are of the same
% dimension as rates and each element corresponds to the calc start and end
% date for the corresponding element in rates. So calc_period_start_dates and
% calc_period_end_dates contain n identical rows
day_diff_cal_periods = calc_period_end_dates - calc_period_start_dates;
unique_day_diff_cal_periods = max(day_diff_cal_periods); % get unique cal period durations
dcf_calc_period = unique_day_diff_cal_periods / 365;
% ois_rate is a resulting 1 x m vector containing the ois rate for each
% calc period
ois_rate = (prod(w) - 1) ./ dcf_calc_period;

ois_payment = N * ois_rate .* dcf_calc_period
%pv_total = (fixed_payment - ois_payment) * df