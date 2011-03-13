classdef Random < handle
    
    properties
        seed;  
    end
    
    properties (Constant, Hidden)
        IM1 = 2147483563;
        IM2 = 2147483399;
        AM = 4.656613057391769e-010;
        IMM1 = 2147483562;
        IA1 = 40014;
        IA2 = 40692;
        IQ1 = 53668;
        IQ2 = 52774;
        IR1 = 12211;
        IR2 = 3791;
        NTAB = 32;
        NDIV = 6.710886231250000e+007;
        EPS =  0.00000012;
        RNMX = 0.99999988;
    end
    
    properties (Access = private, Hidden)
        seed2;
        iy;
        iv;
        iset;
        gset;
    end
    
    methods
        
        function obj = Random(seed)
            obj.seed = seed;
            obj.iv = zeros(1, obj.NTAB);
            obj.iy = 0;
            obj.seed2 = 123456789;
            obj.iset = false;
        end
        
        function u = next(obj)
            if (obj.seed <= 0)
                if -obj.seed < 1
                    obj.seed = 1;
                else
                    obj.seed = -obj.seed;
                end
                obj.seed2 = obj.seed;
                for j=obj.NTAB+8:-1:1
                    k = floor(obj.seed / obj.IQ1);
                    obj.seed = obj.IA1 * (obj.seed - k * obj.IQ1) - k * obj.IR1;
                    if (obj.seed < 0)
                        obj.seed = obj.seed + obj.IM1;
                    end
                    if (j <= obj.NTAB)
                        obj.iv(j) = obj.seed;
                    end
                end
                obj.iy=obj.iv(1);
            end

            k = floor(obj.seed / obj.IQ1);
            obj.seed = obj.IA1 * (obj.seed - k * obj.IQ1) - k * obj.IR1;

            if (obj.seed < 0)
                obj.seed =  obj.seed + obj.IM1;
            end

            k = floor(obj.seed2 / obj.IQ2);
            obj.seed2 = obj.IA2 * (obj.seed2 - k * obj.IQ2) - k * obj.IR2;

            if (obj.seed2 < 0)
                obj.seed2 =  obj.seed2 + obj.IM2;
            end

            j = floor(obj.iy / obj.NDIV) + 1;
            obj.iy = obj.iv(j) - obj.seed2;
            obj.iv(j) = obj.seed;

            if (obj.iy < 1)
                obj.iy = obj.iy + obj.IMM1;
            end

            u = min(obj.AM * obj.iy, obj.RNMX);
            
        end
        
        function z = nextn(obj)
            if ~obj.iset
                rsq = 0;
                while (rsq >= 1 || rsq == 0)
                    v1 = 2 * obj.next - 1;
                    v2 = 2 * obj.next - 1;
                    rsq = v1 * v1 + v2 * v2;            
                end

                fac = sqrt(-2 * log(rsq) / rsq);
                obj.gset = v1 * fac;
                obj.iset = true;
                z = v2 * fac;
            else
                obj.iset = false;
                z = obj.gset;
            end
        end
        
    end
end    