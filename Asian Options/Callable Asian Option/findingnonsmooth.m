function P = findingnonsmooth(S,CP,K,alp,Spg,df,r,b,sig,ti,t,T,C,N)

inival = 115; % initial guess value

if(length(Spg)==0)
        P = fzero('difference2',inival,[],CP,K,alp,Spg,df,r,b,sig,ti,t,T,C,N);
else
    if (ti(length(Spg))==t)
        P = fzero('difference1',inival,[],CP,K,alp,Spg,df,r,b,sig,ti,t,T,C,N);
    else
        P = fzero('difference2',inival,[],CP,K,alp,Spg,df,r,b,sig,ti,t,T,C,N);
    end

end

return;
