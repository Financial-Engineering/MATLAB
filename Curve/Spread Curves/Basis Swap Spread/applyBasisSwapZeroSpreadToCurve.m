% Apply the spread curve (both MM and XCCY) to the base swap (yield) curve for
% pricing basis swap.
% curve is a normal yield curve
function [curve] = applyBasisSwapZeroSpreadToCurve(spread_curve, base_curve, value_date, dcc)
    % find the union of all tenor dates from base swap curve and zero spread
    % curve
    spread_curve_tenors = cell2mat(spread_curve(:,1));
    base_curve_tenors = cell2mat(base_curve(:,1));
    master_tenors = union(spread_curve_tenors, base_curve_tenors); % results are ordered
    curve(:,1) = num2cell(master_tenors);
    dfs_base_curve = getDFsFromCurve(base_curve, value_date, master_tenors); % assume linear interpolation here - should be made configurable
    zero_spreads = getOrdinatesFromCurve(spread_curve, master_tenors); % assume linear interpolation of zero spreads
    taus = findDaysFraction(value_date, master_tenors, dcc);
    new_dfs = dfs_base_curve .* exp(-zero_spreads .* taus);
    curve(:,2) = num2cell(new_dfs);
end