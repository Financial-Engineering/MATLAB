
function [r seed] = ran2(seed)
      
    IM1 = 2147483563;
    IM2 = 2147483399;
    AM = 1 / IM1;
    IMM1 = IM1 - 1;
    IA1 = 40014;
    IA2 = 40692;
    IQ1 = 53668;
    IQ2 = 52774;
    IR1 = 12211;
    IR2 = 3791;
    NTAB = 32;
    NDIV =(1 + IMM1 / NTAB);
    EPS = 1.2e-7;
    RNMX =(1.0 - EPS);

    persistent seed2 iy iv;

    if isempty(iv)
        iv = zeros(1, NTAB);
        iy = 0;
        seed2 = 123456789;
    end
        
    if (seed <= 0)
        if -seed < 1
            seed = 1;
        else
            seed = -seed;
        end
        seed2 = seed;
        for j=NTAB+8:-1:1
            k = floor(seed / IQ1);
            seed = IA1 * (seed - k * IQ1) - k * IR1;
            if (seed < 0)
                seed = seed + IM1;
            end
            if (j <= NTAB)
                iv(j) = seed;
            end
        end
        iy=iv(1);
    end
    
    k = floor(seed / IQ1);
    seed=IA1*(seed - k * IQ1) - k * IR1;
    
    if (seed < 0)
        seed =  seed + IM1;
    end
    
    k = floor(seed2 / IQ2);
    seed2 = IA2 * (seed2 - k * IQ2) - k * IR2;
    
    if (seed2 < 0)
        seed2 =  seed2 + IM2;
    end
    
    j = floor(iy / NDIV) + 1;
    iy = iv(j) - seed2;
    iv(j) = seed;
    
    if (iy < 1)
        iy = iy + IMM1;
    end
    
    r = min(AM * iy, RNMX);

end
