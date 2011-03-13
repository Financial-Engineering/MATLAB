function acc = AccruedPremium(base,tn,df,hzd)

    function t = DeltaT(t1,t2)
        t = (t1 - t2) / 365; 
    end

    function prem = Premium(t)
        dfi = Interpolate(df(:,1),df(:,2),t,@Linear);
        hzi = Interpolate(hzd(:,1),hzd(:,2),DeltaT(t,base),@LogLinear);
        prem = DeltaT(t,tn(1)) .* dfi .* hzi;
    end

    acc = quadl(@Premium,tn(1),tn(2)) ;
end
