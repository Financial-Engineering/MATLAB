% Double barrier digital knock-in call
function [ c ] = dbldigkic( S,K,L,U,r,b,sig,T )    
    c = K * exp(-r * T) - dbldigkoc( S,K,L,U,r,b,sig,T );
end