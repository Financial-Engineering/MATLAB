function [dates] = genCashflowDates(start_date, end_date, frequency_term, frequency_base, dcc, bdc, calendars)
    i=1;
    date = start_date;   
    while (date < end_date)
        if (nargin > 6) % calendars included
            date = calcEndDates(start_date, i * frequency_term, frequency_base, dcc, bdc, calendars);
        else
            date = calcEndDates(start_date, i * frequency_term, frequency_base, dcc, bdc);
        end
        if (date <= end_date)
            dates(i) = date;
        end
        i = i + 1;
    end
end