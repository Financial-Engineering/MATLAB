classdef RatioReader < handle
    %RatioReader Parses Razor ratio file and header into MATLAB objects
    %   Initialize with the name of the ratio set, requires both the ratio
    %   header file *.xml and ratio binary in the same directory
    
    properties (Access = private, Hidden)
        xp;
        columns;
        rowsPerBlock;
        name;
        rateClassMap;
    end    
    
    properties (SetAccess = private)
        paths;
        seed;
        eigenValues;
        confidence;
        model;
        
        baseDate;
        startDate;
        endDate;
        
        nodeDates;
        ratioTable;
        statisticsTable;

    end
    
    methods (Access = private, Hidden)
        
        %% Parse ratio metadata
        function parseHeader(obj,file)
            obj.xp = Xpath([file '.xml'],'f');
            
            obj.columns = obj.xp.double('//matrix/@columns');
            obj.rowsPerBlock = obj.xp.double('//matrix/@rowsPerBlock');
            obj.name = obj.xp.string('//matrix/@name');
            
            obj.paths = obj.xp.double('//simulation/@paths');
            obj.seed = obj.xp.double('//simulation/@seed');
            obj.eigenValues = obj.xp.double('//simulation/@numberEigenValues');
            obj.confidence = obj.xp.double('//simulation/@confidenceLevel');
            obj.model = obj.xp.string('//simulation/@model');
            
            obj.baseDate = obj.xp.date('//baseDate/text()');
            obj.startDate = obj.xp.date('//startDate/text()');
            obj.endDate = obj.xp.date('//endDate/text()');       
        end
       
        %% Column/Rateclass map for indexing into ratio matrix
        function buildRateClassMap(obj)
                      
            r = obj.xp.string('//marketRate/@name');
            c = obj.xp.double('//marketRate/column/text()');

            obj.rateClassMap = containers.Map(r,c);

        end
        
        %% Read Ratio file and store in ratio table
        function buildRatioTable(obj)
            % add code to properly handle sequence #'s.
            % for now assume only 1 file, hence the _0 suffix
            file = [cell2mat(obj.name) '_0'];
            
            m = memmapfile(file, 'Format' , ...
                {'double', [length(obj.nodeDates), obj.columns, obj.paths] 'x'});
            
            obj.ratioTable = m.Data(1).x;
        end
        
        %% Build credit node date structure
        function buildNodeDates(obj)
            obj.nodeDates = obj.baseDate;
            
            % TODO: Has to be a way to do this with a single xpath stmt!
            
                        % Handle Days
            n = obj.xp.double('//creditNode/@days');
            for i=1:length(n)
                obj.nodeDates = [obj.nodeDates; addtodate(obj.baseDate, n(i), 'day')];
            end
            
                        % Handle Weeks
            n = obj.xp.double('//creditNode/@weeks');
            for i=1:length(n)
                obj.nodeDates = [obj.nodeDates; addtodate(obj.baseDate, n(i) * 7, 'day')];
            end
            
                        % Handle Months
            n = obj.xp.double('//creditNode/@months');
            for i=1:length(n)
                obj.nodeDates = [obj.nodeDates; addtodate(obj.baseDate, n(i), 'month')];
            end
            
                        % Handle Years
            n = obj.xp.double('//creditNode/@years');
            for i=1:length(n)
                obj.nodeDates = [obj.nodeDates; addtodate(obj.baseDate, n(i), 'year')];
            end

        end 
        
    end
    
    methods
        
        %% Contructor for RatioReader
        function obj = RatioReader(file)
            obj.parseHeader(file);
            obj.buildNodeDates();
            obj.buildRateClassMap();
            % obj.buildRateStatistics();
            obj.buildRatioTable();
        end

        %% Return a specific path for every credit node date
        function r = getRatioPath(obj, rateClass, path)
            r = obj.ratioTable(:, obj.rateClassMap(rateClass), path);
        end
        
        %% Return a list of rate classes
        function r = getRateClasses(obj)
            r = keys(obj.rateClassMap);
        end
    end
    
end

