function F = buildFlows(tau,periods,rate)
    % Generate par bond cash flows
    n = tau * periods;

    F = [[linspace(1 / periods, tau, n)' ...
          ones(n, 1) * rate / periods * 100]; [tau 100]];

end