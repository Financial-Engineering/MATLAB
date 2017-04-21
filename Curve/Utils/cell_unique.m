% Return a unique array of cells by the column index.
% occurance={'first','last'}, and the corresponding occurance position is
% kept. Default is 'first'. If need_sort is set to 'sort' then sorting is
% performed. Default sorting is skipped.
function [out_cells] = cell_unique(in_cells, column_index, occurance, need_sort)
    out_cells = in_cells;
    if (nargin < 3)
        occurance = 'first';        
    end
    if (nargin < 4)
        need_sort = 'nosort';
    end
    duplicates = cell2mat(in_cells(:,column_index));
    [u1 u2 u3] = unique(duplicates, occurance);
    id = [1:length(duplicates)];
    sd = setdiff(id, u2);
    out_cells(sd,:) = []; % erase all duplicates
    
    % sort if required
    if (strcmp(need_sort, 'sort'))
        % insert codes for sorting here!!!        
    end
end