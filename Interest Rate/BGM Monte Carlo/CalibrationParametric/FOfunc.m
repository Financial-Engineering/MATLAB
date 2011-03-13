function ret = FOfunc(v,T,i)

global t;

    s=0;
    for i=1:T(end),
        s=s+Ifunc(v,t,T,i);
    end
    ret = s;
        