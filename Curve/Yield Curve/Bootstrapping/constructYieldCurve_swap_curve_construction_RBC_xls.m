setGlobalVariables;

load ('mat files\curve_config_swap_curve_construction_RBC_xls.mat');

contracts_config{1} = {'mm', 2, @calcMMZeroRate2, 'ACT/365', 'MODFOLLOWING'}; % mm
contracts_config{2} = {'swap', 3, @calcSWAPZeroRate2, 'ACT/365', 'MODFOLLOWING'}; % swap

% Altermative MM contracts : {contract term, contract term base,
% annualised simple rate} - Annualised simple rates = zero rate
contracts{1,1} = 6;
contracts{1,2} = 'm';
contracts{1,3} = 0.009849991363355;
contracts{2,1} = 1;
contracts{2,2} = 'y';
contracts{2,3} = 0.013149998032463;

% swap contracts : {contract term, contract term base, frequency term,
% frequency base, annualized swap rate}
contracts{3,1} = 2;
contracts{3,2} = 'y';
contracts{3,3} = 6;
contracts{3,4} = 'm';
contracts{3,5} = 0.018804;
contracts{4,1} = 3;
contracts{4,2} = 'y';
contracts{4,3} = 6;
contracts{4,4} = 'm';
contracts{4,5} = 0.02333;
contracts{5,1} = 4;
contracts{5,2} = 'y';
contracts{5,3} = 6;
contracts{5,4} = 'm';
contracts{5,5} = 0.026857;

[yieldCurve yield_curve_config] = bootstrap(contracts_config, contracts, curve_config)