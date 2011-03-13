function z = gasdev(seed)

    persistent iset gset;
    
    if isempty(iset)
        rsq = 0;
        while (rsq >= 1 || rsq == 0)
            
			v1 = 2 * ran2(seed) - 1;
			v2 = 2 * ran2(seed) - 1;

			rsq = v1 * v1 + v2 * v2;            
        end
        
        fac = sqrt(-2 * log(rsq) / rsq);
		gset = v1 * fac;
		iset = 1;
		z = v2 * fac;
    else
        iset = [];
        z = gset;
    end
        
end