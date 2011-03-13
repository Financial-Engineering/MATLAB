% Input variables from user
%today = 40271 + 693960; % convert from excel to matlab dates
today = 732651; % 05-Dec-2005

contracts_config{1} = {'mm', 5, @calcMMZeroRate2, 'ACT/365', 'MODPRECEDING'}; % mm
%contracts_config{2} = {'fut', 2, @calcFUTZeroRate, 'ACT/360', 'NONE'}; % fut
contracts_config{2} = {'swap', 2, @calcSWAPZeroRate, 'ACT/365', 'MODPRECEDING'}; % swap

%mm1 = CreateMM('1M','ACT/365', 'MODPRECEDING', 0.04);

%swapCurve = [mm1m mm2m swap1y swap2y];

% Define all contract values below
% money market contracts : {contract term, contract term base, face value, price}
%contracts{1,1} = 1;
%contracts{1,2} = 'd';
%contracts{1,3} = 100;
%contracts{1,4} = 94;
%contracts{2,1} = 1;
%contracts{2,2} = 'm';
%contracts{2,3} = 100;
%contracts{2,4} = 95;
%contracts{3,1} = 3;
%contracts{3,2} = 'm';
%contracts{3,3} = 100;
%contracts{3,4} = 96;

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

% future contracts : {contract start date, contract end date, price}
%contracts{4,1} = 40362 + 693960; % starting in 3m
%contracts{4,2} = 40454 + 693960; % matures in 6m
%contracts{4,3} = 96;
%contracts{5,1} = 40362 + 693960; % starting in 3m
%contracts{5,2} = 40546 + 693960; % matures in 9m
%contracts{5,3} = 97;
%contracts{6,1} = 40362 + 693960; % starting in 3m
%contracts{6,2} = 40636 + 693960; % matures in 1y
%contracts{6,3} = 98;


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


% bond contracts : {}

yieldCurve = bootstrap(contracts_config, contracts, today)