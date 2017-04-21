function [spreadCurve] = constructSpreadCurve(type)
   setGlobalVariables;
    
   load ('mat files/spreadCurve_config.mat');
   load ('mat files/data_name_list.mat');

   tn = spreadCurve_config(:,1);
   ti = findIndexOfValue(type, tn, 'first');
   filenames = data_name_list(ti,:);
   data_path = spreadCurve_config{ti,3}; % each spread curve mat files data path
   for i=1:length(filenames)
       if (isstr(filenames(i)) || iscellstr(filenames(i)))
           %data_path = char(data_paths{i}); % convert from cell string to char string
           filename = char(filenames(i));
           filename = strcat(filename,'.mat');
           filename_path = strcat('mat files\', data_path);
           filename_path = strcat(filename_path, '\');
           filename_path = strcat(filename_path, filename);
           load (filename_path);
       end
   end

   % Need to change the following calls so that it dynamically pass in the
   % input parmameters
   %spreadCurve = spreadCurve_config{ti,2} (dom_yield_curve, for_yield_curve, fwd_points, spot_rate, value_date, spot_date, DCC); % type=FXYield
   %spreadCurve = spreadCurve_config{ti,2} (basis_swap_MM_tenors, benchmark_yield_curve, basis_swap_MM_market_spreads, value_date, spot_lag, DCC, BDC, calendars); % type=BasisSwapZeroSpreadMM
   spreadCurve = spreadCurve_config{ti,2} (basis_swap_XCCY_tenor, non_benchmark_yield_curve, basis_swap_XCCY_market_spreads, value_date, spot_lag, DCC, BDC, calendars); % type=BasisSwapZeroSpreadXCCY
end