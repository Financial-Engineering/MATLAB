function [R] = BBI(ref,days,fv)
% -------------------------------------------------------------------------
% [R] = BBI(ref,days)
% This function calculates the UBS Warburg Bank Bill Index.
%
% [R] = output matrix table of BBI rate calculations.
% ref = vector of reference rates.
% days = vector of maturity dates.
% fv = vector of face values.
% -------------------------------------------------------------------------

ref = ref(:);
days = days(:);
fv = fv(:);
if (length(days)~=length(fv))
    fprintf('Vector dimension does not match.\n');
    return;
end
check = find(days<0 | days>91);
if(check~=0)
    fprintf('The maturity days must fall within [0,91].\n');
    return;
end
ndays = length(days);
rates = zeros(ndays,1);
for i=1:ndays
    if (days(i)>=0 & days(i)<=7)
        rates(i) = ref(1);
        1
    elseif (days(i)>=8 & days(i)<=14)
        rates(i) = 2/3*ref(1)+1/3*ref(2);
        2
    elseif (days(i)>=15 & days(i)<=21)
        rates(i) = 1/3*ref(1) + 2/3*ref(2);
        3
    elseif (days(i)>=22 & days(i)<=28)
        rates(i) = ref(2);
        4
    elseif (days(i)>=29 & days(i)<=35)
        rates(i) = 8/9*ref(2)+1/9*ref(3);
        5
    elseif (days(i)>=36 & days(i)<=42)
        rates(i) = 7/9*ref(2)+2/9*ref(3);
        6
    elseif (days(i)>=43 & days(i)<=49)
        rates(i) = 6/9*ref(2)+3/9*ref(3);
        7
    elseif (days(i)>=50 & days(i)<=56)
        rates(i) = 5/9*ref(2)+4/9*ref(3);
        8
    elseif (days(i)>=57 & days(i)<=63)
        rates(i) = 4/9*ref(2)+5/9*ref(3);
        9
    elseif (days(i)>=64 & days(i)<=70)
        rates(i) = 3/9*ref(2)+6/9*ref(3);
        10
    elseif (days(i)>=71 & days(i)<=77)
        rates(i) = 2/9*ref(2)+7/9*ref(3);
        11
    elseif (days(i)>=78 & days(i)<=84)
        rates(i) = 1/9*ref(2)+8/9*ref(3);
        12
    else
        rates(i) = ref(3);
        13
    end
end

df = 1./(1 + rates.*(days/365));
pv = fv.*df;

[R] = [days rates fv df pv];
