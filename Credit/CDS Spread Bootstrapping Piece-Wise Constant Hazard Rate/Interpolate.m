function y=Interpolate(y,x,x1,method)

    % Search column 1 for the last pt < x1
    i = find(x < x1, 1, 'last');
    
    if i ~= length(x)
        y = method(y(i:i+1),x(i:i+1),x1);
    else
        y = y(i);
    end
end