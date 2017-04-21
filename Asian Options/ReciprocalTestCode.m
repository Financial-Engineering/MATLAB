% This program tests the code for Reciprocal Asian option.

% Sum of lognormal pdf must equal to one.
sumpdf = [integrate('lognormalpdf',1000,0,1000,'c',1,1,0,0.2); ... 
            integrate('lognormalpdf',1000,0,10000,'c',1,1,1,0.4); ... 
            integrate('lognormalpdf',1000,0,10000,'c',1,1,2,0.6); ...
            integrate('lognormalpdf',1000,0,10000,'c',1,1,3,0.8); ... 
            integrate('lognormalpdf',1000,0,10000,'c',1,1,4,1)];
        
if(abs(norm(sumpdf-ones(length(sumpdf),1),inf))<0.0001)
    fprintf('The pdf sum is correct.\n');
else
    fprintf('The pdf sum is not corect.\n');
end
fprintf('\n');

fprintf('Price of call must decrease when asset price increases.\n');
Reciprocal('c',10,50,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('c',20,50,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('c',30,50,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('c',40,50,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('c',50,50,0.05,0.05,0.5,360,50,0,1,0,1)
fprintf('\n');

fprintf('Price of put must increase when asset price increases.\n');
Reciprocal('p',10,30,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('p',20,30,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('p',30,30,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('p',40,30,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('p',50,30,0.05,0.05,0.5,360,50,0,1,0,1)
fprintf('\n');

fprintf('Test for maturity mismatch.\n');
fprintf('Prices must decrease when maturity increases.\n');
Reciprocal('c',10,30,0.05,0.05,0.5,360,50,0,1,0,1)
Reciprocal('c',20,30,0.05,0.05,0.5,360,50,0,1,0,1.2)
Reciprocal('c',30,30,0.05,0.05,0.5,360,50,0,1,0,1.4)
Reciprocal('c',40,30,0.05,0.05,0.5,360,50,0,1,0,1.6)
Reciprocal('c',50,30,0.05,0.05,0.5,360,50,0,1,0,1.8)
fprintf('\n');

fprintf('Price of call should be similar to 1/Sbar.\n');
Reciprocal('c',10,50000,0,0,0.15,1,10,0,0.1,0,0.1)
fprintf('1/Sbar = %.4f.\n', 1/10);
Reciprocal('c',20,50000,0,0,0.15,1,20,0,0.1,0,0.1)
fprintf('1/Sbar = %.4f.\n', 1/20);
Reciprocal('c',30,50000,0,0,0.15,1,30,0,0.1,0,0.1)
fprintf('1/Sbar = %.4f.\n', 1/30);
Reciprocal('c',40,50000,0,0,0.15,1,40,0,0.1,0,0.1)
fprintf('1/Sbar = %.4f.\n', 1/40);
Reciprocal('c',50,50000,0,0,0.15,1,50,0,0.1,0,0.1)
fprintf('1/Sbar = %.4f.\n', 1/50);
fprintf('\n');

fprintf('Price of put should be similar to 1/K.\n');
Reciprocal('p',50000,10,0,0,0.15,1,500000,0,0.1,0,0.1)
fprintf('1/K = %.4f.\n', 1/10);
Reciprocal('p',50000,20,0,0,0.15,1,500000,0,0.1,0,0.1)
fprintf('1/K = %.4f.\n', 1/20);
Reciprocal('p',50000,30,0,0,0.15,1,500000,0,0.1,0,0.1)
fprintf('1/K = %.4f.\n', 1/30);
Reciprocal('p',50000,40,0,0,0.15,1,500000,0,0.1,0,0.1)
fprintf('1/K = %.4f.\n', 1/40);
Reciprocal('p',50000,50,0,0,0.15,1,500000,0,0.1,0,0.1)
fprintf('1/K = %.4f.\n', 1/50);
fprintf('\n');
