%% Credit Default Swap Piece-Wise Hazard Rate Bootstrapping
% 
% 

function [sp,hz]=CDSBootstrap(rr,df,spread)
%% Input Parameters
%
% <html>
% <table border=1>
% <tr><td>rr</td><td>Recovery Rate</td></tr>
% <tr><td>df</td><td>Discount Factors</td></tr>
% <tr><td>spread</td><td>Market credit default swap spreads</td></tr>
% </table>
% </html>
%
%% Output Parameters
%
% <html>
% <table border=1>
% <tr><td>sp</td><td>Survival Probabilities</td></tr>
% <tr><td>hz</td><td>Hazard Rates</td></tr>
% </table>
% </html>

%% Hazard Rate Function
%
% $$ h\left(\cdot\right) = \mbox{max}\left(-\frac{\mbox{ln}\frac{p_{i+1}}{p_{i}}}{\Delta T},0\right) $$
%
    function hz = HazardRate(sp1,sp2,dt)
        hz = max(-log(sp2/sp1)/dt,0);
    end

    delta = spread(:,1) - [0;spread(1:end-1,1)];
    spread = spread(:,2);
    df = df(:,2);
    
    rr = 1 - rr;
    
    sp = ones(length(spread),1);
    hz = zeros(length(spread),1);
    
    %%
    %
    % $$
    % p_0=\left(\frac{r-\frac{1}{2}\delta_0\Delta_0}{r+\frac{1}{2}\delta_0\Delta_0}\right)
    % $$
    f = 0.5 * spread(1) * delta(1);
    sp(1) = (rr - f) / (rr + f);
    
    %%
    %
    % $$ \lambda_0=h\left(1,p_0,\delta_0\right) $$
    hz(1) = HazardRate(1,sp(1),delta(1));
    
    for i=2:length(spread)
        
        k = i-1;
        sp1 = [1;sp(1:k-1)];

        s1 = sum(df(1:k).*sp(1:k).*delta(1:k));
        s2 = sum(df(1:k).*(sp1-sp(1:k)).*(delta(1:k)));
        s3 = sum(df(1:k).*(sp1-sp(1:k)));

        %%
        %
        % $$ A=-{{\delta }_{i}}\left[ \left(
        % \sum\limits_{k=1}^{i-1}{d{{f}_{k}}{{p}_{k}}{{\Delta
        % }_{k}}+\frac{1}{2}\sum\limits_{k=1}^{i-1}{d{{f}_{k}}\left[
        % {{p}_{k}}-{{p}_{k-1}} \right]{{\Delta }_{k}}+\frac{1}{2}d{{f}_{i}}{{p}_{i-1}}{{\Delta }_{i}}}}
        % \right)+r\left( \sum\limits_{k=1}^{i-1}{d{{f}_{k}}\left[ {{p}_{k}}-{{p}_{k-1}} \right]
        % +{{p}_{i-1}}}d{{f}_{i}} \right) \right] $$
        %
        A = -spread(i)*(s1 + 0.5*s2 + 0.5*df(i)*sp(i-1)*delta(i)) ...
            + rr * (s3 + sp(i-1) * df(i));
        
        %%
        %
        % $$ B=d{{f}_{i}}{{p}_{i-1}}\left( \frac{1}{2}{{\delta
        % }_{i}}{{\Delta }_{i}}+r \right) $$
        %
        B = df(i) * sp(i-1) * (0.5 * spread(i) * delta(i) + rr);

        %%
        %
        % $$ p_i=p_{i-1}\left(\frac{A}{B}\right) $$
        %
        sp(i) = sp(i-1) * (A / B);
        
        if sp(i) > sp(i-1)
            sp(i) = sp(i-1);
            hz(i) = 0;
        else
            hz(i) = HazardRate(sp(i-1),sp(i),delta(i));
        end
        
    end
end