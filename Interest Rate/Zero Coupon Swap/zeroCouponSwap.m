% This file returns three types of interest calculated on the fixed leg of
% a zero coupon swap.

%if strcmp(daycount, '30/365')
    % do nothing, assume days_diff_start_maturity already contains the correct number
%else % assume 'ACT/365' by default
    %days_diff_start_maturity = t_maturity - t_start;
%end

days_diff_start_maturity = t_maturity - t_start;
dcf_start_maturity = days_diff_start_maturity / 365; % for all 365 dc


% calc simple interest
interest_simple = N * r * dcf_start_maturity
pv_interest_simple = df * interest_simple


% calc compound interest
% assume dc is always 'ACT/365' for the floating leg for now
dcf_calc_periods = (calc_period_end_dates - calc_period_start_dates) / 365;
interest_compound = N * (prod(1 + r * dcf_calc_periods) - 1)
pv_interest_compound = df * interest_compound


% calc actuarial interest
interest_actuarial = N * ((1 + r) ^ dcf_start_maturity - 1)
pv_interest_actuarial = df * interest_actuarial

%interest_simple_error = interest_simple - razor_interest_simple
%pv_interest_simple_error = pv_interest_simple - razor_pv_interest_simple
%interest_compound_error = interest_compound - razor_interest_compound
%pv_interest_compound_error = pv_interest_compound - razor_pv_interest_compound
%interest_actuarial_error = interest_actuarial - razor_interest_actuarial
%pv_interest_actuarial_error = pv_interest_actuarial - razor_pv_interest_actuarial