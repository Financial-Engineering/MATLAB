function [parameter] = fitting(data)
% -----------------------------------------------------
% This function fits the synchronous jump model 
% for each of the day in the given data 
% using the non-linear least square
% -----------------------------------------------------

number = count(data);

k = 1;
datacount = 0;
% Calculating the non-linear least sqaure day-by-day for
% the whole data set
while (number ~= 0)

    datacount = datacount + 1
    
    [variable, resnorm] = lsqnonlin(@(z0) newSSE(z0,data,number),[5 0.01 -0.5 0.6 0.08],[0 0 -0.8 0 0 ],[50 5 1 2 1],optimset('Display','Iter','MaxIter',30000,'MaxFunEvals',500000));
    
    estimation(k,:) = variable;
    difference(k,1) = resnorm;
    date(k,1) = data(1,1);
    data(1:number,:) = [];

    number = count(data);

    k = k + 1;

end

[parameter] = [date estimation difference];

end
