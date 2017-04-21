function P = swaptionBlack(S,f,K,C,ti,t)

% --------------------------------------------------------------
% P = swaptionBlack(S,f,K,C,F,ti,t)
% This function calcuates the price of Bermudan swatpion using LIBOR market
% model using Longstaff Schwartz algorithm.
%
% P = output price.
% S = current spot rate.
% f = vector of forward rates.
% K = strike price.
% C = covariance matrix.
% ti = vector of tenor time points.
% t = current time.
% --------------------------------------------------------------

    ti = ti(:);
    f = f(:);
    n = length(f);
    
    if(length(C)~=n)
        fprintf('Dimension is not correct.\n');
        return;
    end
    
    if(length(ti)~=n)
        fprintf('Dimension is not correct.\n');
        return;
    end
    
    if(t==ti(n))
        fprintf('Current rate is at terminal point.\n');
        return;
    end
    
    currentIndex = find(ti<=t);
    if(isempty(currentIndex))
        currentIndex = 0;
    end
    
    currentIndex = max(currentIndex);

    if(currentIndex>=n)
        fprintf('There are no future values.\n');
        return;
    end
    
    tau = [ti(1);ti(2:length(ti)) - ti(1:length(ti)-1)];

    Pit = ones(length(ti),1);
    Pit(1) = 1/(S*tau(1)+1);
    Pit(2) = 1/((S*tau(1)+1)*(f(1)*tau(2)+1));
    Pit(3) = 1/((S*tau(1)+1)*(f(1)*tau(2)+1)*(f(2)*tau(3)+1));
    summing = tau(2)*Pit(2)+tau(3)*Pit(3);
    
    Swap = 0;
    for i=2:length(ti)
        w = tau(i)*Pit(i)/summing;
        Swap = Swap + w*f(i-1);
    end
    
    %w2 = tau(2)*Pit(2)/summing;
    %w3 = tau(3)*Pit(3)/summing;
    %Vab = 1/Swap^2*(w2*w2*f(1)*f(1)*C(2,2) + w2*w3*f(1)*f(2)*C(2,3) + w3*w2*f(3)*f(2)*C(3,2) + w3*w3*f(3)*f(3)*C(3,3))
    Vab = 0.152;

    d1 = (log(Swap/K)+Vab^2/2)/Vab;
    d2 = (log(Swap/K)-Vab^2/2)/Vab;
    
    %(Swap*cnorm(d1)-K*Pit(1)*cnorm(d2))*summing
    
    P=(Swap*cnorm(d1)-K*cnorm(d2))*summing;
end