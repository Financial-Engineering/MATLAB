% This program tests the LevyFixedEqual, LevyVariableFixing and DARO pricing model.

fprintf('The following call prices are produced using DARO, Levy Fixed\n');
fprintf('and Levy Variable with fixed weighting.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');

DARO(1,100,100,1,0,[0.5;0.5],[0.5;0.5],100,100,0.05,0.05,0.15,2,2,[0;1],[0;1],0,1)
LevyFixEqual('c',100,100,0.05,0.05,0.15,1,100,0,1,0,1)
LevyVariableFixing('c',100,100,[0.5;0.5],100,0.05,0.05,0.15,2,[0;1],0,1)

fprintf('\n');
fprintf('The following put prices are produced using DARO, Levy Fixed\n');
fprintf('and Levy Variable with fixed weighting.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');
DARO(-1,100,100,1,0,[0.5;0.5],[0.5;0.5],100,100,0.05,0.05,0.15,2,2,[0;1],[0;1],0,1)
LevyFixEqual('p',100,100,0.05,0.05,0.15,1,100,0,1,0,1)
LevyVariableFixing('p',100,100,[0.5;0.5],100,0.05,0.05,0.15,2,[0;1],0,1)

fprintf('\n');
fprintf('The following call prices are produced using DARO, Levy Fixed\n');
fprintf('and Levy Variable with fixed weighting using daily prices.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');

alp = 1/360*ones(360,1);
Spg = 100;
ti = linspace(0,1,360)';

DARO(1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,360,360,ti,ti,0,1)
LevyFixEqual('c',100,100,0.05,0.05,0.15,359,100,0,1,0,1)
LevyVariableFixing('c',100,100,alp,Spg,0.05,0.05,0.15,360,ti,0,1)

fprintf('\n');
fprintf('The following put prices are produced using DARO, Levy Fixed\n');
fprintf('and Levy Variable with fixed weighting using daily prices\n');
fprintf('for the forward-start case.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');

alp = 1/360*ones(360,1);
Spg = 100;
ti = linspace(0.5,1,360)';

DARO(-1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,360,360,ti,ti,0.1,1)
LevyFixEqual('p',100,100,0.05,0.05,0.15,359,105,0.5,1,0.1,1)
LevyVariableFixing('p',100,100,alp,Spg,0.05,0.05,0.15,360,ti,0.1,1)

fprintf('\n');
fprintf('The following call prices are produced using DARO, Levy Fixed\n');
fprintf('and Levy Variable with fixed weighting using daily prices\n');
fprintf('for the in-progress case.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');

alp = 1/360*ones(360,1);
Spg = 105*ones(180,1);
ti = linspace(0,1,360)';
t = ti(180,1);

DARO(1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,360,360,ti,ti,t,1)
LevyFixEqual('c',100,100,0.05,0.05,0.15,359,105,0,1,t,1)
LevyVariableFixing('c',100,100,alp,Spg,0.05,0.05,0.15,360,ti,t,1)

fprintf('\n');
fprintf('The following call prices are produced using DARO, Levy Fixed\n');
fprintf('and Levy Variable with fixed weighting using daily prices\n');
fprintf('for the exercise for certain case.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');

alp = 1/360*ones(360,1);
Spg = 105*ones(180,1);
ti = linspace(0,1,360)';
t = ti(180,1);

DARO(1,100,50,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,360,360,ti,ti,t,1)
LevyFixEqual('c',100,50,0.05,0.05,0.15,359,105,0,1,t,1)
LevyVariableFixing('c',100,50,alp,Spg,0.05,0.05,0.15,360,ti,t,1)

fprintf('\n');
fprintf('The following put prices are produced using DARO, Levy Fixed\n');
fprintf('and Levy Variable with fixed weighting using daily prices\n');
fprintf('for the out-of-money for certain case.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');

alp = 1/360*ones(360,1);
Spg = 105*ones(180,1);
ti = linspace(0,1,360)';
t = ti(180,1);

DARO(-1,100,50,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,360,360,ti,ti,t,1)
LevyFixEqual('p',100,50,0.05,0.05,0.15,359,105,0,1,t,1)
LevyVariableFixing('p',100,50,alp,Spg,0.05,0.05,0.15,360,ti,t,1)

fprintf('\n');
fprintf('The following call prices are produced using DARO and Levy Fixed\n');
fprintf('with variable weighting using daily prices\n');
fprintf('for the maturity matching case.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');

alp = [0.1;0.2;0.3;0.4];
Spg = 100;
ti = [0;0.2;0.4;0.6];
DARO(1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,4,4,ti,ti,0,0.6)
LevyVariableFixing('c',100,100,alp,Spg,0.05,0.05,0.15,4,ti,0,0.6)

fprintf('\n');
fprintf('The following call prices are produced using DARO and Levy Fixed\n');
fprintf('with variable weighting using daily prices\n');
fprintf('for the maturity mistach case.\n');
fprintf('The prices are expected to be similar\n');
fprintf('and smaller than the previous two prices.\n');
fprintf('\n');

alp = [0.1;0.2;0.3;0.4];
alp1 = [0.4;0.3;0.2;0.1];
Spg = 100;
ti = [0;0.2;0.4;0.6];
DARO(1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,4,4,ti,ti,0,1)
LevyVariableFixing('c',100,100,alp,Spg,0.05,0.05,0.15,4,ti,0,1)

fprintf('\n');
fprintf('The following call prices are produced using DARO and Levy Fixed\n');
fprintf('with variable weighting using daily prices\n');
fprintf('for the maturity mistach case for future comparison purposes.\n');
fprintf('The prices are expected to be similar\n');

alp = [0.1;0.2;0.3;0.4];
Spg = [150;100];
ti = [0;0.2;0.4;0.6];
DARO(1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,4,4,ti,ti,0.2,1)
LevyVariableFixing('c',100,100,alp,Spg,0.05,0.05,0.15,4,ti,0.2,1)

fprintf('\n');
fprintf('The following call prices are produced using DARO and Levy Fixed\n');
fprintf('with variable weighting using daily prices\n');
fprintf('for the maturity mistach case.\n');
fprintf('The weights are reversed so less weightings\n');
fprintf('on smaller asset prices.\n');
fprintf('The prices are expected to be similar\n');
fprintf('and bigger than the previous two prices.\n');
fprintf('\n');

alp = [0.4;0.3;0.2;0.1];
Spg = [150;100];
ti = [0;0.2;0.4;0.6];
DARO(1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,4,4,ti,ti,0.2,1)
LevyVariableFixing('c',100,100,alp,Spg,0.05,0.05,0.15,4,ti,0.2,1)
fprintf('\n');
fprintf('The following put prices are produced using DARO and Levy Fixed\n');
fprintf('with variable weighting using daily prices\n');
fprintf('for the maturity mismatch case for future comparison purposes.\n');
fprintf('The prices are expected to be similar.\n');
fprintf('\n');

alp = [0.1;0.2;0.3;0.4];
Spg = [105;100];
ti = [0;0.2;0.4;0.6];
DARO(-1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,4,4,ti,ti,0.2,1)
LevyVariableFixing('p',100,100,alp,Spg,0.05,0.05,0.15,4,ti,0.2,1)

fprintf('\n');
fprintf('The following call prices are produced using DARO and Levy Fixed\n');
fprintf('with variable weighting using daily prices\n');
fprintf('for the maturity mistach case.\n');
fprintf('The weights are reversed so less weightings\n');
fprintf('on smaller asset prices.\n');
fprintf('The prices are expected to be similar\n');
fprintf('and smaller than the previous two prices.\n');
fprintf('\n');

alp = [0.4;0.3;0.2;0.1];
Spg = [105;100];
ti = [0;0.2;0.4;0.6];
DARO(-1,100,100,1,0,alp,alp,Spg,Spg,0.05,0.05,0.15,4,4,ti,ti,0.2,1)
LevyVariableFixing('p',100,100,alp,Spg,0.05,0.05,0.15,4,ti,0.2,1)
