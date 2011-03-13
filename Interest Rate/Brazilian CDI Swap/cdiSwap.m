%bus_days = setdiff(flat_days, holidays);
%bus_days = bus_days + 693960; % convert from excel to matlab
%bus_days_days = weekday(bus_days);
%bus_days_indices = find((bus_days_days ~= 1) & (bus_days_days ~= 7));
%bus_days = bus_days(bus_days_indices);

% check on some simple errors
%u_day_count = unique(day_count);
%if (length(u_day_count) ~= 1)
%    error('different day counts in different cashflows');    
%end
%if (strcmp(u_day_count,'BUS/252') == false)
%    error('day count is not set to BUS/252');
%end
dc = 1 / 252;

%n = length(bus_days);

% calculate fixed leg NPV
NPV_fixed = N * ((1 + k)^((n-1) / 252) - 1) * df_payment % (n-1) only if number of bus_days are calculated, for manually entered n, the number entered has to be (length+1)

% calculate floating leg NPV
NPV_float = N * (prod(1+D)^dc /  df_maturity - 1) * df_payment

NPV = NPV_fixed - NPV_float