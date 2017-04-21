function val = bsval(PC, S, X, tau, r, sigma, ipr)
% -----------------------------------------------------
% Written by Michael Shou-Cheng Lee (z3049978)
% Math5335: Assignment 1
% -----------------------------------------------------
% val = bsval(PC, S, X, tau, r, sigma, ipr)
%
% ------------Purpose of the Function------------------
% This function evaluates the price for European call
% and put option using the Black-Scholes model.
%
% --------------- Input Arguments ---------------------
% PC:       'P' or 'p' evaluates the price for
%           European put option. 'C' or 'c' evaluates
%           the price for European call option.
% S:        The current stock price.
% X:        The strike price.
% tau:      Time-to-maturity of the option.
% r:        The risk-free interest rate.
% sigma:    The volatility.
% ipr:      If ipr > 0, a summary print of the input
%           values, the calculated option value
%           and the time taken for the caculation is
%           presented. If ipr = 0, only the option price
%           is presented. Default value of ipr is 0.
% Input arguments can be scalars, vectors or arrays.
% If more than one argument are vectors or arrays,
% the dimensions must agree.
%
% --------------- Output Arguments --------------------
% If ipr = 1, the output contains the summary of the
% input values, the calculated option value and the time
% taken for the calculation.
% If ipr = 0, the output contains the calculated option
% value.
% -----------------------------------------------------

% To set up a time counter
time = cputime;
% To set ipr = 0 as a default value
if nargin == 6
    ipr = 0;
end

% To check for insufficient number of input arguments
if nargin < 6
    fprintf('There are not enough input arguments.\n');
    return;
end

% To check the validity of the PC input
if strcmp(PC,'C') ~= 1 && strcmp(PC,'c') ~= 1 && ...
        strcmp(PC, 'P') ~= 1 && strcmp(PC,'p') ~= 1
    fprintf('Input %s is an unrecognisable option type.\n', PC);
    return;
end

% To check the dimensions of the input variables
% If more than one input variables is a vector/array,
% size for input variables must be equal
Sdim1 = size(S,1);
Xdim1 = size(X,1);
taudim1 = size(tau,1);
rdim1 = size(r,1);
sigmadim1 = size(sigma,1);
Sdim2 = size(S,2);
Xdim2 = size(X,2);
taudim2 = size(tau,2);
rdim2 = size(r,2);
sigmadim2 = size(sigma,2);
dimcounter = 0;
if Sdim1 > 1 | Sdim2 > 1
    dimcounter = dimcounter + 1;
end
if Xdim1 > 1 | Xdim2 > 1
    dimcounter = dimcounter + 1;
end
if taudim1 > 1 | taudim2 > 1
    dimcounter = dimcounter + 1;
end
if rdim1 > 1 | rdim2 > 1
    dimcounter = dimcounter + 1;
end
if sigmadim1 > 1 | sigmadim2 > 1
    dimcounter = dimcounter + 1;
end

if dimcounter > 1
    if Sdim1 ~= Xdim1 | Sdim1 ~= taudim1 | Sdim1 ~= rdim1 ...
            | Sdim1 ~= sigmadim1 | Sdim2 ~= Xdim2 ...
            | Sdim2 ~= taudim2 | Sdim2 ~= rdim2 ...
            | Sdim2 ~= sigmadim2
        fprintf('Input dimension does not match\n');
        return;
    end
end

% To check the validity of the stock price
if size(find(S<0),1) * size(find(S<0),2) > 0
    fprintf('Input elements for stock price S must all be non-negative.\n');
    return;
end
% To check the validity of the strike price
if size(find(X<0),1) * size(find(X<0),2) > 0
    fprintf('Input elemetns for strike price X must all be non-negative.\n');
    return;
end
% To check the validity of the time-to-maturity
if size(find(tau<0),1) * size(find(tau<0),2) > 0
    fprintf('Input elements for time-to-maturity tau must all be non-negative.\n');
    return;
end
% To check the validity of the risk-free rate
if size(find(r<0),1) * size(find(r<0),2) > 0
    fprintf('Input elements for risk-free-rate r must all be non-negative.\n');
    return;
end
if size(find(sigma<0),1) * size(find(sigma<0),2) > 0
    fprintf('Input elements for volatility sigma must all be non-negative.\n');
    return;
end

% To check the validity of the ipr input
if ipr < 0
    fprintf('Input ipr = %d is invalid.\n', ipr);
    fprintf('ipr should be greater than or equal to 0.\n');
    return;
end

% Calculate d1 and d2. Note that boundary values are
% explicitly stated to avoid possible NaN errors in running
% the function
if S == X & tau == 0
    d1 = 0;
else
    d1 = (log(S./X)+(r+sigma.^2/2).*tau)./(sigma.*sqrt(tau));
end

d2 = d1 - sigma.*sqrt(tau);

% Calculate the option values
if strcmp(PC,'C') == 1 | strcmp(PC,'c') == 1
    if X == inf
        value = 0;
    else
        value = S.*normcdf(d1) - (X.*exp(-r.*tau)).*normcdf(d2);
    end
else
    if S == inf
        value = 0;
    else
        value = (X.*exp(-r.*tau)).*normcdf(-d2) - S.*normcdf(-d1);
    end
end

if ipr > 0
    fprintf('Black and Scholes formula for value of an option\n');
    fprintf('Asset price = %.4f\n', S);
    fprintf('Strike price = %.4f\n', X);
    fprintf('Time to expiry = %.2f years\n', tau);
    fprintf('Risk free rate = %.2f%%\n', r*100);
    fprintf('Volatility = %.2f%%\n', sigma*100);
    if strcmp(PC,'C') == 1 | strcmp(PC,'c') == 1
        fprintf('Value of Call option = %.5f\n', value);
    else
        fprintf('Value of Put option = %.5f\n', value);
    end

    % Evaluate the time take
    time = cputime - time;
    fprintf('The time taken for calculation = %.5f seconds\n', time);
else
    val = value;
end

end
