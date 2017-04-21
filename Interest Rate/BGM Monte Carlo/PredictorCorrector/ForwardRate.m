%% Simply-Compounded Forward Interest rate (1.20) p. 12
%% INPUTS:
%% P = Zero-Coupon Bond
%% tau = accrual interest

function ret = ForwardRate(P,tau)
   F=zeros(size(P,1)-1,1);
   for i=1:size(F),
      F(i)=(P(i)/P(i+1)-1)/tau;
   end
   ret = F;
   
