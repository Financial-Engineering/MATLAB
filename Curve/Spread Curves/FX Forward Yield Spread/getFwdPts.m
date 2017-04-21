% Get fwd points (may need to interpolate or extrapolate) from fwd point
% curve for the given set of fwd_dates
function [fps] = getFwdPts(fwd_pts, fwd_dates)
    ins = (fwd_dates >= fwd_pts{1,1}) & (fwd_dates <= fwd_pts{end,1}); % interpolate
    ins_fwd_dates1 = ins .* fwd_dates;
    ins_fwd_dates2 = fwd_pts{end,1} * ~ins;
    ins_fwd_dates = ins_fwd_dates1 + ins_fwd_dates2; % replace all dates outside the curve date range to be the end date of the curve to avoid NaN during interpolation
    outs = (fwd_dates < fwd_pts{1,1}) | (fwd_dates > fwd_pts{end,1}); % extrapolate
    outs_fwd_dates = outs .* fwd_dates;
    fp_dates = cell2mat(fwd_pts(:,1)); % extract all point fwd pts dates - x
    fps = cell2mat(fwd_pts(:,2)); % extract all fwd pts - y
    if (max(outs) > 0) % some dates need extrapolation
        % Extrapolate
        outs_fps = interp1(fp_dates, fps, outs_fwd_dates, 'linear', 'extrap'); % given x, y, fwd_dates (xi), extrapolate (linearly) yi (yss)
        outs_fps = outs_fps .* outs;
    end
    if (max(ins) > 0) % some dates need interpolation
        % Interpolate
        ins_fps = interp1(fp_dates, fps, ins_fwd_dates); % given x, y, fwd_dates (xi), interpolate (linearly) yi (yss)
        ins_fps = ins_fps .* ins;
    end
    e = 0;
    if (exist('ins_fps'))
        e = e + 1;
    end    
    if (exist('outs_fps'))
        e = e + 2;
    end
    if (e == 1)
        fps = ins_fps;
    elseif (e == 2)
        fps = outs_fps;
    else % both ins_fps & outs_fps exist
        fps = ins_fps + outs_fps; % merge the two
    end        
end