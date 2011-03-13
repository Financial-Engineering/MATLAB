function y=LogLinear(y,x,x1)
   y = (y(2)/y(1))^((x1-x(1))/(x(2)-x(1)))*y(1);
end
