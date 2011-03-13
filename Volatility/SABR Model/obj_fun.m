% The goal is to minimize the objective function
function [sse] = obj_fun(obj_values, min_parms, model_parms, model)
    error = model(min_parms, model_parms) - obj_values;
    sse = sum(error.^2); % sum of square of errors
end