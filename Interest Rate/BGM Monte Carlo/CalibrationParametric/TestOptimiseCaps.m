function TestOptimiseCaps
    
v_init=[0.1 0.1 0.1 0.1]
[v, f]=fminsearch(@optimiseCaps,v_init);
%v_init = [0.1 0.1 0.1 0.1];
