% inputs:-
% "samples" - a m*n matrix of input observed samples, where m is the number
% of sequence for normality test and n is the number of observed sample per sequence.
% "expected_moments" - a m*n matrix containing n expected moments of each
% of the m selected moments in time.
% "tolerence" - maximum error tolerence in percentage of the measured
% moments
% output:-
% "failed" - 0 if passed all tests, and 1 if any test failed
% "failed_test" - [GOF, mean, variance]
% "stats.observed_moments" - [mean, variance, skewness, kurtosis]
% "stats.observed_alphas" - observed failure rate for chi-sq GOF tests, mean test and var test (100 runs are performed for each test).
% It is expected that this value is close to the default input alpha value
% (0.05).
% "stats.meantest_observed_alpha" - observed failure rate for mean test.
% "stats.vartest_observed_alpha" - observed failure rate for var test.

function [failed failed_test stats] = normalityTests(samples, expected_moments)

    failed = 0;
    num_of_sequences = size(samples,2);
    failed_test = zeros(num_of_sequences,3);
    
    % moments estimation
    mu = mean(samples);
    stats.observed_moments = mu';
    v = var(samples);
    stats.observed_moments = [stats.observed_moments v'];
    s = skewness(samples);
    stats.observed_moments = [stats.observed_moments s'];
    k = kurtosis(samples);
    stats.observed_moments = [stats.observed_moments k'];    
    
    stats.observed_alphas = zeros(num_of_sequences,3);
    stats.gof_observed_alpha = zeros(1,num_of_sequences); % observed alpha for GOF test on normality for each series
    stats.meantest_observed_alpha = zeros(1,num_of_sequences); % observed alpha for mean test for each series 
    stats.vartest_observed_alpha = zeros(1,num_of_sequences); % observed alpha for var test for each series 
    for i=1:num_of_sequences
        % test 1 - goodness-of-fit (chi-sq test)
        h_total = 0;        
        for j=1:100 % Default significant level is 5%, so repeats 100 times, failure rate should be no more than 20% (4 times the stated average 5%)
            [h,p] =  chi2gof(samples(:,i), 'alpha', 0.01);
            h_total = h_total + h;
        end
        stats.observed_alphas(i,1) = h_total / 100;
        if (h_total > 20)
            failed = 1;
            failed_test(i,:) = [1 1 1];
        else
             % test 2 - hypothesis testing on 1st and 2nd moments
            h1_total = 0; h2_total = 0;
            for j=1:100
                [h1,p1] = ttest(samples(:,i), expected_moments(1,i), 0.01); % mean test assuming independent normal
                [h2,p2] = vartest(samples(:,i), expected_moments(2,i), 0.01); % var test assuming independent normal
                h1_total = h1_total + h1;
                h2_total = h2_total + h2;
            end
            stats.observed_alphas(i,2) = h1_total / 100;
            stats.observed_alphas(i,3) = h2_total / 100;
            if (h1_total > 20)
                failed = 1;
                failed_test(i,2) = h1;
            end
            if (h2_total > 20)
                failed = 1;
                failed_test(i,3) = h2;
            end
        end
        
        % test 3 - hist plot
        figure
        histfit(samples(:,i));
        if (num_of_sequences == 1)
            title('Histogram plot for Test A');
        else
            title(['Histogram plot for Test B - at t', num2str(i)]);
        end

        % test 4 - qq plot
        figure
        qqplot(samples(:,i));
        if (num_of_sequences == 1)
            title('Q-Q plot for Test A');
        else
            title(['Q-Q plot for Test B - at t', num2str(i)]);
        end            

        % test 5 - box plot
        figure
        boxplot(samples(:,i));
        if (num_of_sequences == 1)
            title('Box plot for Test A');
        else
            title(['Box plot for Test B - at t', num2str(i)]);
        end            
        
    end    
 
end