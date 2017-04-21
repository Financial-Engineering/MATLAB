function [P] = jumpP(returndata,d)

% -------------------------------------------------------------------------
% [nj kappa gamma] = jumpP(returndata,d)
% This program estimates the jump parameters from price return data.
%
% [P] = output vector representing the number of jumps,
%                    the mean of the jump and the standard deviation of the
%                    jump.
% returndata = log return of prices.
% d = number of standard deviations above the mean to be classified as a 
%     jump.
% -------------------------------------------------------------------------
if(d<3)
    fprintf('This degree is too low to be classified as jumps.\n');
    return;
end
returndata = returndata(:);
n = length(returndata);
returndata = log(returndata(2:n)./returndata(1:n-1))
average = mean(returndata);
s = std(returndata);
number = length(find(returndata>average+s*d|returndata<average-s*d));
temp = returndata;
while number>0
    index = find(temp>average+s*d|temp<average-s*d);
    temp(index) = [];
    if(length(temp)==0)
        fprintf('The data has too many jumps.\n');
        return;
    end
    average = mean(temp);
    s = std(temp);
    number = length(find(temp>average+s*d|temp<average-s*d));
end
index = find(returndata>average+s*d|returndata<average-s*d);
jumpdata = returndata(index);
nj = length(jumpdata);
kappa = mean(jumpdata);
gamma = std(jumpdata);

if length(index)==0
    P = [0;0;0]
else
    P = [nj;kappa;gamma];
end
