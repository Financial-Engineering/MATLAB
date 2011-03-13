% Input variables from user
%today = 734388; % 07-Sep-2010
%today = 734258; % 30-Apr-2010
today = 734167; % 29-Jan-2010

contracts_config{1} = {'mm', 4, @calcMMZeroRate2, 'ACT/365', 'MODFOLLOWING'}; % mm
contracts_config{2} = {'swap', 11, @calcSWAPZeroRate, 'ACT/365', 'MODFOLLOWING'}; % swap

% Altermative MM contracts : {contract term, contract term base,
% annualised simple rate} - Annualised simple rates = zero rate
contracts{1,1} = 1;
contracts{1,2} = 'd';
contracts{1,3} = 0.045;
contracts{2,1} = 1;
contracts{2,2} = 'm';
contracts{2,3} = 0.0472;
contracts{3,1} = 3;
contracts{3,2} = 'm';
contracts{3,3} = 0.0496;
contracts{4,1} = 6;
contracts{4,2} = 'm';
contracts{4,3} = 0.049333404;

% swap contracts : {contract term, contract term base, frequency term,
% frequency base, annualized swap rate}
contracts{5,1} = 1;
contracts{5,2} = 'y';
contracts{5,3} = 6;
contracts{5,4} = 'm';
contracts{5,5} = 0.049441453;
contracts{6,1} = 2;
contracts{6,2} = 'y';
contracts{6,3} = 6;
contracts{6,4} = 'm';
contracts{6,5} = 0.0505;
contracts{7,1} = 3;
contracts{7,2} = 'y';
contracts{7,3} = 6;
contracts{7,4} = 'm';
contracts{7,5} = 0.0513125;
contracts{8,1} = 4;
contracts{8,2} = 'y';
contracts{8,3} = 6;
contracts{8,4} = 'm';
contracts{8,5} = 0.0534625;
contracts{9,1} = 5;
contracts{9,2} = 'y';
contracts{9,3} = 6;
contracts{9,4} = 'm';
contracts{9,5} = 0.054575;
contracts{10,1} = 7;
contracts{10,2} = 'y';
contracts{10,3} = 6;
contracts{10,4} = 'm';
contracts{10,5} = 0.0563125;
contracts{11,1} = 10;
contracts{11,2} = 'y';
contracts{11,3} = 6;
contracts{11,4} = 'm';
contracts{11,5} = 0.0575125;
contracts{12,1} = 15;
contracts{12,2} = 'y';
contracts{12,3} = 6;
contracts{12,4} = 'm';
contracts{12,5} = 0.0584625;
contracts{13,1} = 20;
contracts{13,2} = 'y';
contracts{13,3} = 6;
contracts{13,4} = 'm';
contracts{13,5} = 0.057725;
contracts{14,1} = 30;
contracts{14,2} = 'y';
contracts{14,3} = 6;
contracts{14,4} = 'm';
contracts{14,5} = 0.05475;
contracts{15,1} = 60;
contracts{15,2} = 'y';
contracts{15,3} = 6;
contracts{15,4} = 'm';
contracts{15,5} = 0.05475;

yieldCurve = bootstrap(contracts_config, contracts, today)