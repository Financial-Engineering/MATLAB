% Two-dimensional plot of function
function[y] = graphSABRSurface(x1, x2, fn, model_parms,vol_m)
    [X1 X2] = meshgrid(x1,x2);
    n1 = size(X1,1);
    n2 = size(X1,2);
    y = zeros(size(X1));
    for i=1:n1
        for j=1:n2
            X = [X1(i,j) X2(i,j)];
            yi = obj_fun(vol_m, X, model_parms, fn);
            if (isnan(yi) || ~isreal(yi))
                y(i,j) = max(max(y));
            else
                y(i,j) = yi;
            end
        end
    end
    surf(X1, X2, y);
end