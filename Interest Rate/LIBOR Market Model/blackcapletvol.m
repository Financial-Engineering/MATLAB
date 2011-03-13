function BCV = blackcapletvol(sig,ti,t)
% -----------------------------------------------------------------
% BCV = blackcapletvol(sig,ti,t)
% This function calculates the required implied volatilities
% for calibration.
%
% BCV = output vector of required market volatilities.
% ti = vector of tenor dates.
% t = valutatoin date.
% -----------------------------------------------------------------

sig = sig(:);
ti = ti(:);
n = length(sig);
if (length(sig)~=length(ti))
    fprintf('Dimension is not correct.\n');
    return;
end
currentIndex = find(ti<=t);
if(length(currentIndex)==0)
    currentIndex = 0;
end
currentIndex = max(currentIndex);
if (currentIndex>=n)
    fprintf('There are no future values.\n');
    return;
end
if(currentIndex~=0 & norm(sig(1:currentIndex),inf)~=0)
    fprintf('Past volatilities are assumed to be zeros.\n');
    return;
end

BCV = (ti-t).*sig.^2;
