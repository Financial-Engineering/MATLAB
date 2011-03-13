function [ndays] = findDaysDiff(start_dates, end_dates, dcc)
    if (nargin < 3)
        dcc = 'ACT/360'; % default
    end
    if (strcmp(dcc,'ACT/360') || strcmp(dcc,'ACT/365'))
        ndays = end_dates - start_dates; % julian diff
    elseif (strcmp(dcc,'30/360') || strcmp(dcc,'30/365'))
        [y1 m1 d1] = datevec(start_dates);
        [y2 m2 d2] = datevec(end_dates);
        %ndays = ((y2-y1) * 12 + (m2-m1)) * 30 + (d2-d1);
        %ndays = 360 * (y2-y1) + 30 * (m2-m1) + (d2-d1);
        num_of_months = (y2-y1) * 12 + (m2-m1);
        g = d1 > 29;
        if (d2(g) == 31)
            d2(g) = 30;
        end
        d1(g) = 30;
        ndays = num_of_months * 30 + d2 - d1;
    end
end