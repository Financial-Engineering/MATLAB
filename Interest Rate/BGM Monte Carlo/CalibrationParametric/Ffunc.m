function ret = Ffunc(v)

v

global T;
global i;
global t;

ret = (v(1)+(v(2)+v(3)*(T(i)-t)/360)*exp(-v(4)*(T(i)-t)/360))^2;