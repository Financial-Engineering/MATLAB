% Turbo-Warrant Call
% Richard Lewis - RRT Ltd.

% S - spot
% K - strike
% H - lower barrier
% sig - volatility
% r - risk free rate
% q - dividend yield
% T - time to expiry in years
% T0 - time to barrier in years

function [p]=TurboWarrantCall(S,K,H,sig,r,q,T,T0)

    function [p]=DownOutCall(S,K,H,sig,r,q,T)
        b = r - q;

        mu1 = b + (sig^2) / 2;
        mu2 = b - (sig^2) / 2;

        sigT = sig * sqrt(T);

        d1 = (log(S / H) + mu1 * T) / sigT;
        d2 = (log(H / S) + mu1 * T) / sigT;
        d3 = (log(S / H) - mu2 * T) / sigT;
        d4 = (log(H / S) - mu2 * T) / sigT;

        dfr = exp(-r * T);
        dfq = exp(-q * T);

        p = S * dfq * cnorm(d1) ...
            - H * (H / S)^((2 * b) / sig^2) * dfq * cnorm(d2) ...
            - K * dfr * cnorm(d3) ...
            + K * (H / S)^((2 * mu2) / sig^2) * dfr * cnorm(d4);
    end

    function [p]=LookBackCall(S,Smin,sig,r,q,T)
        b = r - q;

        mu1 = b + (sig^2)/2;
        mu2 = b - (sig^2)/2;

        sigT = sig * sqrt(T);

        d1 = (log(S/Smin) + mu1 * T)/sigT;
        d2 = (log(Smin/S) - mu1 * T)/sigT;
        d3 = (log(S/Smin) - mu2 * T)/sigT;
        d4 = (log(Smin/S) + mu2 * T)/sigT;  

        dfr = exp(-r*T);
        dfq = exp(-q*T);

        if b ~= 0
            st = (sig^2/(2*b)) * S * dfr * (S/Smin)^(-2*b/sig^2) * cnorm(d4) ...
                - (sig^2/(2*b)) * S * dfq * cnorm(d2);
        else
            st = S * dfr * sigT * (cnorm(d1) + d1 * (cnorm(d1) - 1));
        end

        p = S * dfq * cnorm(d1) - Smin * dfr * cnorm(d3) + st;
    end

    function [p]=DigitalBarrierIn(S,L,sig,r,q,T)
        b = r - q;

        mu1 = b + 0.5 * sig * sig;
        mu2 = b - 0.5 * sig * sig;
        mu3 = sqrt(mu2^2 + 2 * r * sig^2);

        sigT = sig * sqrt(T);

        p = ((S/L)^((mu3-mu1)/sig^2) * cnorm((log(L/S) - mu3*T)/sigT) ...
            +(S/L)^((-mu3-mu1)/sig^2) * cnorm((log(L/S) + mu3*T)/sigT));
    end

    p = DownOutCall(S,K,H,sig,r,q,T) ...
        + ((LookBackCall(H,K,sig,r,q,T0) - LookBackCall(H,H,sig,r,q,T0)) ...
        * DigitalBarrierIn(S,H,sig,r,q,T));
end
