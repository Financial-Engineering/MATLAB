function [daysfracs] = findDaysFraction(start_dates, end_dates, dcc)
    if (nargin < 3)
        dcc = 'ACT/360'; % default
    end
    ndays = findDaysDiff(start_dates, end_dates, dcc);
    if (strcmp(dcc,'ACT/360') || strcmp(dcc,'30/360'))
        daysfracs = ndays / 360;
    elseif (strcmp(dcc,'ACT/365') || strcmp(dcc,'30/365'))
        daysfracs = ndays / 365;
    end
end