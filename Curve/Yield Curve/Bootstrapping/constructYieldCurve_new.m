% Input variables from user
%today = 734388; % 07-Sep-2010
today = 734258; % 30-Apr-2010

contracts_config{1} = {'mm', 5, @calcMMZeroRate2, 'ACT/365', 'MODPRECEDING'}; % mm
contracts_config{2} = {'swap', 2, @calcSWAPZeroRate, 'ACT/365', 'MODPRECEDING'}; % swap

% Altermative MM contracts : {contract term, contract term base,
% annualised simple rate} - Annualised simple rates = zero rate
contracts{1,1} = 1;
contracts{1,2} = 'd';
contracts{1,3} = 0.0438;
contracts{2,1} = 1;
contracts{2,2} = 'm';
contracts{2,3} = 0.0441;
contracts{3,1} = 3;
contracts{3,2} = 'm';
contracts{3,3} = 0.04455;
contracts{4,1} = 6;
contracts{4,2} = 'm';
contracts{4,3} = 0.04605;
contracts{5,1} = 9;
contracts{5,2} = 'm';
contracts{5,3} = 0.0475;

% swap contracts : {contract term, contract term base, frequency term,
% frequency base, annualized swap rate}
contracts{6,1} = 1;
contracts{6,2} = 'y';
contracts{6,3} = 3;
contracts{6,4} = 'm';
contracts{6,5} = 0.048223;
contracts{7,1} = 2;
contracts{7,2} = 'y';
contracts{7,3} = 3;
contracts{7,4} = 'm';
contracts{7,5} = 0.048654;

yieldCurve = bootstrap(contracts_config, contracts, today)