% shift a matrix by column. If the input is a row vector, it flips it to a column vector and match shift direction accordingly (i.e. right to down, and left to up).
% If new_element is not defined, the hole will be replaced by 0.
function [out] = shift(in, operation, new_element)
    if (nargin < 3)
        new_element = 0;
    end
    [num_of_rows num_of_cols] = size(in);
    if (num_of_rows == 1) % row vector
        in = in'; % row->col vector
        n = num_of_cols;
    else
        n = num_of_rows;
    end    
    if (strcmp(operation, 'up'))
        out(1:n-1,:) = in(2:n,:);
        out(n,:) = new_element;
    else % 'down'
        out(1,:) = new_element;
        out(2:n,:) = in(1:n-1,:);
    end
    if (num_of_rows == 1) % input is a row vector
        out=out';
    end
end