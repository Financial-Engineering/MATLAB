function P = DoubleWindow(cp,S,K,H,r,b,sig,T)

% -------------------------------------------------------------------------
% P = DoubleWindow(cp,S,K,U,L,r,c,sig,T(1),T(2),T(3))
% This function calculates the price of double window barrier options.
%
% P = output price.
% cp = -1 if call; 1 if put.
% S = spot price.
% K = strike price.
% H = H(1) lower barrier, H(2) upper barrier
% r = risk-free rate.
% c = convenience yield.
% sig = volatility.
% T(1) = barrier start date in years.
% T(2) = barrier end date in years.
% T(3) = expiration date in years.
% -------------------------------------------------------------------------
    theta = cp;

    mu = [b - sig^2/2, b + sig^2/2];

    h = log(H/S);

    dh = h(2)-h(1);
    k = log(K/S);

    rho = [1 sqrt(T(1)/T(2)) sqrt(T(1)/T(3));sqrt(T(1)/T(2)) 1 sqrt(T(2)/T(3));sqrt(T(1)/T(3)) sqrt(T(2)/T(3)) 1];

    function f = phi(mu)
       psi1 = @(a,b,n) tricdf((a-mu*T(1))/(sig*sqrt(T(1))),(b-mu*T(2)-2*n*dh)/(sig*sqrt(T(2))),theta*((k-mu*T(3)-2*n*dh)/(sig*sqrt(T(3)))),rho(1,2),theta*rho(2,3));
       psi2 = @(a,b,n) tricdf((a+mu*T(1))/(sig*sqrt(T(1))),(b-mu*T(2)+2*n*dh)/(sig*sqrt(T(2))),theta*((k-mu*T(3)-2*h(1)+2*n*dh)/(sig*sqrt(T(3)))),-rho(1,2),theta*rho(2,3));

       n = -5:5;
       f = sum(exp(2*mu/sig^2*n*dh)*(psi1(h(2),h(2),n)-psi1(h(2),h(1),n)-psi1(h(1),h(2),n)+psi1(h(1),h(1),n) - ...
               exp(2*mu/sig^2*(h(1)-2*n*dh))*(psi2(h(2),h(2)-2*h(1),n)-psi2(h(2),-h(1),n)-psi2(h(1),h(2)-2*h(1),n)+psi2(h(1),-h(1),n))));

    end

    P = theta * exp(-r*T(3)) * (K * phi(mu(1)) - S * phi(mu(2)));

end
