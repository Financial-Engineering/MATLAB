%% Equity Swap
% Returns the present value of the equity leg of a total return equity
% swap. Dividends can either be a continous yield or discrete payments
%%
function [p tbl]=EquitySwap(N,dfs,S,S0,q,divs,reset,payment,dt0,DCB1,DCB2)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>N</td><td>Notional as the number of shares</td></tr>
% <tr><td>S</td><td>Spot price at valuation date</td></tr>
% <tr><td>S0</td><td>Last reset before valuation date</td></tr>
% <tr><td>q</td><td>Constant dividend yield</td></tr>
% <tr><td>divs</td><td>n x 2 vector of dates and dividend amount (can be null)</td></tr>
% <tr><td>reset</td><td>n x 2 pairs of rate start and end dates</td></tr>
% <tr><td>payment</td><td>cash flow payments dates</td></tr>
% <tr><td>dt0</td><td>valuation date</td></tr>
% <tr><td>DCB1,DCB2</td><td>day count basis of reset and payment periods</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>p</td><td>Present value of the equity swap leg</td></tr>
% <tr><td>tbl</td><td>Table of detailed cashflows</td></tr>
% </table>
% </html>

    %% Filter Past Cashflows
    range=(payment>=dt0);
    payment=payment(range);
    reset=reset(range,:);
    
    deltaT1 = (reset(:,2) - reset(:,1)) / DCB1;
    deltaT2 = (reset(:,2) - reset(:,1)) / DCB2;
    
    k = 1;
        
    cf = zeros(length(payment),1);
    df = ones(length(payment),2);

    df_p = ones(length(payment),1);
    fwd =  zeros(length(payment),1);
    pr =  zeros(length(payment),1);
    
    %% Initial Cashflow for prior start
    % $$ CF_0 = \left \{ \begin{array}{ll} {df_{pay_{1}}N \left[
    % \frac{S_t e^{b_1 \Delta t_1}}{S_0}-1\right]} & {t > t_0} \\ 0 & \mbox{otherwise} \end{array} \right.$$       
    if dt0 > reset(1)
        dt1 = max((reset(1,2) - dt0) / DCB1, 0);
        dt2 = max((reset(1,2) - dt0) / DCB2, .25/DCB2);
        
        df(1,1) = 1;
        df(1,2) = Interpolate(dfs(:,2),dfs(:,1),reset(2),@LogLinear);
        
        df_p(1) = Interpolate(dfs(:,2),dfs(:,1),payment(1),@LogLinear);
        
        qr = exp(q*dt1);
        fwd(1) = (df(1,1) / df(1,2) / qr - 1) / dt2;

        pr(1) = S * exp(fwd(1) * dt1) / S0 - 1;
        cf(1) = N(1) * df_p(1) * pr(1);
        deltaT1(1) = dt1;
        
        k = 2;
    end

    %% Iterate over cashflows
    %
    % $$ i=k,\cdots,N $$
    for i=k:length(payment);
        
        %% Discrete dividends between reset periods
        % 
        % $$ div_i = \left \{ \begin{array}{ll} {\sum_{j}df_{j}Div_{j}} & {q=0} \\ 0 & \mbox{otherwise} \end{array} \right. $$
        %
        % $$ 1{\hskip -3 pt}\hbox{I} \qquad \qquad $$
        div = 0;
        if q == 0
            if ~isempty(divs)
                div = sum(find(divs(:,1)>=reset(i)&&divs(:,1)<reset(i+1))) * dfs(:,i);
            end
        end
                
        %% Calculate the forward cost of carry
        %
        % $$ b_{fwd_i}=\frac{\left(\frac{df_{start}}{df_{end}}\right)e^{-q\Delta t_i}-1}{\Delta
        % t_i} $$
        df(i,1) = Interpolate(dfs(:,2),dfs(:,1),reset(i,1),@LogLinear);
        df(i,2) = Interpolate(dfs(:,2),dfs(:,1),reset(i,2),@LogLinear);

        qr = exp(q*deltaT2(i)); 
        fwd(i) = (df(i,1) / df(i,2) / qr - 1) / deltaT2(i);
                      
        %% Cash Flow Generation
        % 
        % $$ CF_i=N_i\left[df_{pay_{i}}\left(e^{b_{fwd_i}\Delta t_{i}}-1\right)+div_i\right] $$
        df_p(i) = Interpolate(dfs(:,2),dfs(:,1),payment(i),@LogLinear);
        pr(i) = exp(fwd(i) * deltaT1(i)) - 1; 
        cf(i) = N(i) * df_p(i) * pr(i) + div;
    end
    
    %%
    % $$ PV_{equity}=\sum_{i=0}^{n}CF_i $$
    p = sum(cf);
    tbl = [reset payment df fwd pr deltaT1 df_p cf];
end
