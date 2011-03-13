% Remove overlapping contracts (precedence is fut between mm and fut, and
% fut between fut and swap). Between mm and fut, the last mm is
% interpolated between the second last mm and the first fut. Between fut
% and swap, the first swap is interpolated between the last fut and the
% second swap. At the moment, linear df interpolation is assumed. Need to
% change to support other methods.
function [out_curve] = smoothYieldCurve(in_curve)
    % smooth between 'mm' and 'fut' - apply Razor's algorithm
    c1 = cell2mat(in_curve(:,1));
    [sorted_c1, index] = sort(c1);
    out_curve = in_curve(index,:);
    c2 = out_curve(:,2);
    first_fut_i = findIndexOfValue('fut',c2,'first');
    mm_i = findIndexOfValue('mm',c2,'all');
    i_i = intersect(first_fut_i:length(c2), mm_i);
    all = 1:length(c2);
    i = setdiff(all,i_i);
    out_curve = out_curve(i,:);
    start_mm_smooth_i = first_fut_i - 2;
    if ((start_mm_smooth_i < 1) || (~strcmp(out_curve(start_mm_smooth_i,2),'mm')))
        error('cannot smooth curve');
    end        
    
    % smoothing by interpolation
    c1 = cell2mat(out_curve(:,1)); % x's
    c4 = cell2mat(out_curve(:,4)); % y's
    interp_set = [start_mm_smooth_i first_fut_i];
    x = c1(interp_set);
    y = c4(interp_set);
    x1 = start_mm_smooth_i + 1;
    y1 = interp1(x,y,c1(x1));
    out_curve{x1,4} = y1;
    
    % smooth between 'fut' and 'swap' - apply Razor's algorithm
    c2 = out_curve(:,2); % from the smoothed out_curve (smoothed on 'mm' and 'fut' side)
    last_fut_i = findIndexOfValue('fut',c2,'last');
    swap_i = findIndexOfValue('swap',c2,'all');
    i_i = intersect(1:last_fut_i, swap_i);
    all = 1:length(c2);
    i = setdiff(all,i_i);
    out_curve = out_curve(i,:);
    c2 = out_curve(:,2);
    start_fut_smooth_i = findIndexOfValue('fut',c2,'last');    
    if (start_fut_smooth_i < 1)
        error('cannot smooth curve');
    end

    % smoothing by interpolation
    c1 = cell2mat(out_curve(:,1)); % x's
    c4 = cell2mat(out_curve(:,4)); % y's
    interp_set = [start_fut_smooth_i start_fut_smooth_i+2];
    x = c1(interp_set);
    y = c4(interp_set);
    x1 = start_fut_smooth_i + 1;
    y1 = interp1(x,y,c1(x1));
    out_curve{x1,4} = y1;    
    
end