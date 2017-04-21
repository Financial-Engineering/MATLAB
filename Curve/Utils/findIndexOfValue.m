% find the index of the first or last occurance of value v in list (a
% column vector)
function [fi] = findIndexOfValue(v, list, position)
    %i = [1:size(list,1)]';
    if (size(list,1) == 1)
        list = list'; % convert to column vector
    end
    i = [1:length(list)]';
    if (isnumeric(v) && (isnan(v)))
        m = isnan(list);
    else
        m = ismember(list,v);
    end
    
    if (sum(m) == 0)
        fi = 0; % if value v is not found in list, returns zero
    elseif strcmp(position, 'first')
        fi = min(nonzeros(i.*m));
    elseif strcmp(position, 'last')
        fi = max(nonzeros(i.*m));
    else
        fi = nonzeros(i.*m);
    end
end