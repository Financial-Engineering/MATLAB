function ret = Ifunc(v,t,T,i)
    
% (v(1)+(v(2)+v(3)*(T(i)-t)/360)*exp(-v(4)*(T(i)-t)/360))^2;
area1 = quad(@(t) (v(1)+(v(2)+v(3)*(T(i)-t)/360)*exp(-v(4)*(T(i)-t)/360))^2, 0, T(i));
area2 = quad(@(t) (v(1)+(v(2)+v(3)*(T(i)-t)/360)*exp(-v(4)*(T(i)-t)/360))^2, 0, T(i-1));

ret = area1 - area2;
   % area1 = quad('Ffunc',0,T(i));
   % area2 = quad('Ffunc',0,T(i-1));
   % ret = area1-area2;
    