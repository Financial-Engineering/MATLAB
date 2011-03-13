% Given start_dates vector, calculate the end_dates vector = (start_dates + terms) based on day
% count convention (dcc) and roll convention (rc)
% All vectors are of same dimension
function [end_dates] = calcEndDates(start_dates, terms, term_bases, dcc, bdc, calendars)
    nc = length(start_dates);
    end_dates = zeros(1,nc); % preallocate
    for i=1:nc
        switch term_bases(i)
            case 'd'
                end_dates(i) = start_dates(i) + terms(i);
            case 'w'
                end_dates(i) = start_dates(i) + terms(i) * 7;
            case 'm'
                if strcmp(dcc, '30/360')
                    end_dates(i) = start_dates(i) + terms(i) * 30;
                else % 'ACT/360', 'ACT/365' or 'ACT/ACT'
                    [y m d] = datevec(start_dates(i));
                    m = m + terms(i);
                    end_dates(i) = convertToValidDate(y, m, d);
                end
            otherwise %'y'
                [y m d] = datevec(start_dates(i));
                end_dates(i) = datenum(y + terms(i), m, d);
        end
    end        
    
    % do business days rolling now
    end_dates = end_dates';
    if (nargin > 5) % calendars included
        if (~strcmp(bdc,'NONE'))
            end_dates = convertToBusDays(end_dates, bdc, calendars);
        end
    else
        if (~strcmp(bdc,'NONE'))
            end_dates = convertToBusDays(end_dates, bdc);
        end        
    end
end

% Convert dates to business days recursively according to the specified business day
% convention
function [bds] = convertToBusDays(dates, bdc, calendars)    
    bds = dates;
    if (nargin > 2) % calendars included
        is_hds = checkBusDays(bds, calendars);
    else
        is_hds = checkBusDays(bds);
    end
    if ((max(is_hds) > 0) && (~strcmp(bdc,'none'))) % there are still holidays and/or weekends - hardcoded to use US cal for now
        switch bdc        
            case 'FOLLOWING'
                bds = bds + is_hds; % add one day in each step
            case 'PRECEDING'
                bds = bds - is_hds; % subtract one day in each step                
            case 'MODFOLLOWING'
                mds = bds + is_hds; % add one day in each step
                is_over_mnt = checkOverMonth(bds, mds);
                if (max(is_over_mnt) > 0)
                    bds = bds + is_hds .* ~is_over_mnt;
                    if (is_hds == is_over_mnt) % all other days are adjusted
                        bdc = 'PRECEDING';
                    end
                else
                    bds = mds;
                end
            case 'MODPRECEDING'
                mds = bds - is_hds; % subtract one day in each step
                is_over_mnt = checkOverMonth(bds, mds);
                if (max(is_over_mnt) > 0)  
                    bds = bds - is_hds .* ~is_over_mnt;
                    if (is_hds == is_over_mnt) % all other days are adjusted
                        bdc = 'FOLLOWING';
                    end
                else
                    bds = mds;
                end                
        end
        if (nargin > 2) % calendars included
            bds = convertToBusDays(bds, bdc, calendars);
        else
            bds = convertToBusDays(bds, bdc);
        end
    end
end

% Return a vector containing 1 if the corresponding date in the dates
% vector is a holiday or weekend and 0 otherwise
function [is_hds] = checkBusDays(dates, calendars)
    % identify weekends first
    ws = weekday(dates);
    is_wknds = (ws == 1) | (ws == 7);
    % identify public holidays
    if (nargin < 2) % no calendar specified - default is USD
        calm = strcat('USD.mat');
        cal_path = strcat('mat files/' ,calm);
        load(cal_path);
    else
        holidays = mergeCalendars(calendars); % col vector holidays consists of holidays from all calendars in row vector calendars    
    end
    is_pubhds = ismember(dates, holidays);
    is_hds = is_wknds | is_pubhds;
end

% Return a vector containing 1 if the corresponding date in the new_dates
% vector is in the same month as the corresponding one in old_dates, and 0
% otherwise
function [is_over_mnt] = checkOverMonth(old_dates, new_dates)
    [oys oms ods] = datevec(old_dates);
    [nys nms nds] = datevec(new_dates);
    is_over_mnt = abs(nms - oms); % 0 if same month and 1 if one month after or before
    if (is_over_mnt == 11)
        is_over_mnt = 1;
    end
end

% Check if a given date in (y m d) format is valid. If it is, return the date in num format, otherwise, roll back to last
% valid date in datenum format.
function lastValidDate = convertToValidDate(y, m, d)
    ok = false;
    lastValidDate = datenum(y, m, d);
    [y1 m1 d1] = datevec(lastValidDate);
    r = mod(m,12);
    if(r==0)
        r = 12;
    end
    m1 = r;
    %y = y + floor(m/12);
    if (d <= eomday(y1,m1))
        ok = true;
    end
    if (~ok)
        lastValidDate = datenum(y1, m1, eomday(y1,m1));
    end
end

% Generate all flat days between and inclusive of start_date and end_date
function [fds] = generateFlatDays(start_date, end_date)
    fds = [start_date:end_date]';
end

% Generate all holidays between and inclusive of start_date and end_date
% according to calendar 'cal'
function [hds] = generateHolidays(start_date, end_date, cal)
    calm = strcat(cal,'.mat');
    cal_path = strcat('mat files/' ,calm);
    all_hds = load(cal_path); % cal.mat file
    hds = all_hds((all_hds >= start_date) & (all_hds <= end_date));    
end

function [no_of_days] = calcDaysInMonth(date)
    v = datevec(date);
    no_of_days = eomday(v(1),v(2));
end