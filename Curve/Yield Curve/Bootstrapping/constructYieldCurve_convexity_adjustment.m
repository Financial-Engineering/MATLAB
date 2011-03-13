setGlobalVariables;

%load ('mat files\futures_convexity_adjustment.mat');

%today = 734535; % '1-feb-2011'

contracts_config{1} = {'mm', 2, @calcMMZeroRate2, 'ACT/365', 'MODFOLLOWING'}; % mm
contracts_config{2} = {'fut', 3, @calcEUROFUTZeroRate, 'ACT/360', 'NONE'}; % fut
contracts_config{3} = {'swap', 3, @calcSWAPZeroRate2, 'ACT/365', 'MODFOLLOWING'}; % swap

% Altermative MM contracts : {contract term, contract term base,
% annualised simple rate} - Annualised simple rates = zero rate
contracts{1,1} = 3;
contracts{1,2} = 'm';
contracts{1,3} = 0.0015;
contracts{2,1} = 6;
contracts{2,2} = 'm';
contracts{2,3} = 0.0017;

% future contracts : {contract start date, contract end date, price}
contracts{3,1} = 734669; % starting in 4m '15-jun-2011' (IMM - third wed in the contract month)
contracts{3,2} = 734761; % matures in 7m '15-sep-2011'
contracts{3,3} = 99.57;
contracts{4,1} = 734767; % starting in 7m '21-sep-2011'
contracts{4,2} = 734858; % matures in 10m '21-Dec-2011'
contracts{4,3} = 99.445;
contracts{5,1} = 734858; % starting in 10m '21-Dec-2011'
contracts{5,2} = 734949; % matures in 13m '21-mar-2012'
contracts{5,3} = 99.035;
%contracts{6,1} = 735040; % starting in 13m '20-jun-2012'
%contracts{6,2} = 735132; % matures in 16m '20-sep-2012'
%contracts{6,3} = 98.725;


% swap contracts : {contract term, contract term base, frequency term,
% frequency base, annualized swap rate}
%contracts{6,1} = 1;
%contracts{6,2} = 'y';
%contracts{6,3} = 6;
%contracts{6,4} = 'm';
%contracts{6,5} = 0.0107;
contracts{6,1} = 2;
contracts{6,2} = 'y';
contracts{6,3} = 6;
contracts{6,4} = 'm';
contracts{6,5} = 0.0177;
contracts{7,1} = 3;
contracts{7,2} = 'y';
contracts{7,3} = 6;
contracts{7,4} = 'm';
contracts{7,5} = 0.0225;
contracts{8,1} = 5;
contracts{8,2} = 'y';
contracts{8,3} = 6;
contracts{8,4} = 'm';
contracts{8,5} = 0.0294;

[yieldCurve yield_curve_config] = bootstrap(contracts_config, contracts, curve_config)