function [days] = calcDaysInYear(dates, dcc)
    l = length(dates);
    days = ones(l,1);
    if (strcmp(dcc,'30/360') || (strcmp(dcc,'ACT/360')))
        days = 360 * days;
    elseif (strcmp(dcc,'ACT/365'))
        days = 365 * days;
    else % 'ACT/ACT'
        vs = datevec(dates);
        days = 365 * days;
        mvs = mod(vs(:,1),4);
        mvs = find(mvs==0);
        days(mvs) = 366;
    end
end