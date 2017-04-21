% T+2 or T+3, etc - 2 or 3 clear business days
function [spot_dates] = calcSpotDates(trade_dates, spot_lags, calendars)
    for i=1:size(trade_dates,1)
        sd = trade_dates(i);
        for j=1:spot_lags(i)
            sd = calcEndDates(sd, 1, 'd', '', 'FOLLOWING', calendars); % add 1 business day at a time
        end
        spot_dates(i) = sd;
    end
end