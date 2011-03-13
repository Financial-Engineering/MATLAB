% Get all the y-ordinates from the curve containing point (x,y) pairs. The
% y-ordinate value of an unspecified x-abscissa value can be found by
% linear interpolation.
function [ordinates] = getOrdinatesFromCurve(curve, abscissas)
    ins = (abscissas >= curve{1,1}) & (abscissas <= curve{end,1}); % interpolate
    ins_abscissas1 = ins .* abscissas;
    ins_abscissas2 = curve{end,1} * ~ins;
    ins_abscissas = ins_abscissas1 + ins_abscissas2; % replace all dates outside the curve date range to be the end date of the curve to avoid NaN during interpolation
    outs = (abscissas < curve{1,1}) | (abscissas > curve{end,1}); % extrapolate
    outs_abscissas = outs .* abscissas;
    curve_abscissas = cell2mat(curve(1:size(curve,1),1)); % extract all abscissas  - x
    curve_ordinates = cell2mat(curve(1:size(curve,1),2)); % extract all ordinates - y
    if (max(outs) > 0) % some points need extrapolation
        % Extrapolate
        outs_short = outs_abscissas < curve{1,1};
        outs_long = outs_abscissas > curve{end,1};        
        % 'Flat'
        outs_ordinates_short = curve_ordinates(1) * outs_short .* ones(size(outs_abscissas));
        outs_ordinates_long = curve_ordinates(end) * outs_long .* ones(size(outs_abscissas));
        outs_ordinates = outs_ordinates_short + outs_ordinates_long;
        % 'linear'
        %outs_ordinates = interp1(curve_abscissas, curve_ordinates, outs_abscissas, 'linear', 'extrap'); % given x, y, abscissas (xi), extrapolate (linearly) yi (ordinates)
        outs_ordinates = outs_ordinates .* outs;
    end
    if (max(ins) > 0) % some dates need interpolation
        % Interpolate
        ins_ordinates = interp1(curve_abscissas, curve_ordinates, ins_abscissas); % given x, y, abscissas (xi), interpolate (linearly) yi (ordinates)
        ins_ordinates = ins_ordinates .* ins;
    end
    e = 0;
    if (exist('ins_ordinates'))
        e = e + 1;
    end    
    if (exist('outs_ordinates'))
        e = e + 2;
    end
    if (e == 1)
        ordinates = ins_ordinates;
    elseif (e == 2)
        ordinates = outs_ordinates;
    else % both ins_ordinates & outs_ordinates exist
        ordinates = ins_ordinates + outs_ordinates; % merge the two
    end
end