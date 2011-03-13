function f = optimiseCaps(v)
    
    global T;
    global volCaplets;
    global i;
    global t;
    
    volCaplets = loadCapletVol; 
    T= 0:0.25:10;
    t = 0; % init.
    s=0;
    
    for i=1:T(end),
        s=s+(FCaplets(T,volCaplets,i)-FOfunc(v,T,i))^2;
    end
    f = sqrt(s);
    
%    v_init=[0.1 0.1 0.1 0.1]
%    [v, f]=fminsearch(@optimiseCaps,v_init);
%     v_init = [0.1 0.1 0.1 0.1];
