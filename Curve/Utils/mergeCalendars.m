function [merged_holidays] = mergeCalendars(calendars)
    num_of_cals = length(calendars);
    calm = strcat(calendars(1),'.mat');
    cal_path = strcat('mat files/',calm);
    load(char(cal_path));
    merged_holidays = holidays;
    if (num_of_cals > 1) % multiple calendars
        for i=2:num_of_cals
            clear holidays;
            calm = strcat(calendars(i),'.mat');
            cal_path = strcat('mat files/',calm);
            load(char(cal_path));
            merged_holidays = union(merged_holidays, holidays);
        end
    end                
end