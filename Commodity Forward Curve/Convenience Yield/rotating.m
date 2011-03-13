function R = rotating(sT)
% -------------------------------------------------------------------------
% R = rotating(sT).
% This program rotates the seasonality vector.
% -------------------------------------------------------------------------

rsT = zeros(length(sT),1);;
for i=1:length(sT)-1
    rsT(i) = sT(i+1);
end
rsT(length(sT)) = sT(1);

R = rsT;
