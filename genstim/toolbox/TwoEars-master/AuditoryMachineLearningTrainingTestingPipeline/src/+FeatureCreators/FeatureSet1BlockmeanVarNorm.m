classdef FeatureSet1BlockmeanVarNorm < FeatureCreators.Base
% uses magnitude ratemap with cubic compression and scaling to a max value
% of one. Reduces each freq channel to its mean and std + mean and std of
% finite differences.

    %% --------------------------------------------------------------------
    properties (SetAccess = private)
        freqChannels;
        freqChannelsStatistics;
        amFreqChannels;
        deltasLevels;
        amChannels;
    end
    
    %% --------------------------------------------------------------------
    methods (Static)
    end
    
    %% --------------------------------------------------------------------
    methods (Access = public)
        
        function obj = FeatureSet1BlockmeanVarNorm( )
            obj = obj@FeatureCreators.Base( 0.5, 0.3, 0.5, 0.5 );
            obj.freqChannels = 16;
            obj.amFreqChannels = 8;
            obj.freqChannelsStatistics = 32;
            obj.deltasLevels = 1;
            obj.amChannels = 4;
        end
        %% ----------------------------------------------------------------

        function afeRequests = getAFErequests( obj )
            afeRequests{1}.name = 'amsFeatures';
            afeRequests{1}.params = genParStruct( ...
                'pp_bNormalizeRMS', false, ...
                'fb_nChannels', obj.amFreqChannels, ...
                'ams_fbType', 'log', ...
                'ams_nFilters', obj.amChannels, ...
                'ams_lowFreqHz', 1, ...
                'ams_highFreqHz', 256' ...
                );
            afeRequests{2}.name = 'ratemap';
            afeRequests{2}.params = genParStruct( ...
                'pp_bNormalizeRMS', false, ...
                'rm_scaling', 'magnitude', ...
                'fb_nChannels', obj.freqChannels ...
                );
            afeRequests{3}.name = 'spectralFeatures';
            afeRequests{3}.params = genParStruct( ...
                'nChannels', obj.freqChannelsStatistics ...
                );
            afeRequests{4}.name = 'onsetStrength';
            afeRequests{4}.params = genParStruct( ...
                'nChannels', obj.freqChannels ...
                );
        end
        %% ----------------------------------------------------------------

        function x = makeDataPoint( obj, afeData )
            rmRL = afeData(2);
            rmR = compressAndScale( rmRL{1}.Data, 0.33, @(x)(median( x(x>0.01) )), 0 );
            rmL = compressAndScale( rmRL{2}.Data, 0.33, @(x)(median( x(x>0.01) )), 0 );
            rm = 0.5 * rmR + 0.5 * rmL;
            spfRL = afeData(3);
            spfR = compressAndScale( spfRL{1}.Data, 0.33, @(x)(median( abs(x(abs(x)>0.01)) )), 1 );
            spfL = compressAndScale( spfRL{2}.Data, 0.33, @(x)(median( abs(x(abs(x)>0.01)) )), 1 );
            spf = 0.5 * spfL + 0.5 * spfR;
            onsRL = afeData(4);
            onsR = compressAndScale( onsRL{1}.Data, 0.33, @(x)(median( x(x>0.01) )), 0 );
            onsL = compressAndScale( onsRL{2}.Data, 0.33, @(x)(median( x(x>0.01) )), 0 );
            ons = 0.5 * onsR + 0.5 * onsL;
            xBlock = [rm, spf, ons];
            x = lMomentAlongDim( xBlock, [1,2,3,4], 1, true );
            for i = 1:obj.deltasLevels
                xBlock = xBlock(2:end,:) - xBlock(1:end-1,:);
                x = [x  lMomentAlongDim( xBlock, [1,2,3,4], 1, true )];
            end
            modRL = afeData(1);
            modR = compressAndScale( modRL{1}.Data, 0.33, @(x)(median( x(x>0.01) )), 0 );
            modL = compressAndScale( modRL{2}.Data, 0.33, @(x)(median( x(x>0.01) )), 0 );
            mod = 0.5 * modR + 0.5 * modL;
            mod = reshape( mod, size( mod, 1 ), size( mod, 2 ) * size( mod, 3 ) );
            x = [x lMomentAlongDim( mod, [1,2,3,4], 1, true )];
            for i = 1:obj.deltasLevels
                mod = mod(2:end,:) - mod(1:end-1,:);
                x = [x lMomentAlongDim( mod, [1,2,3,4], 1, true )];
            end
            % without normalization
            rmRL = afeData(2);
            rmR = compressAndScale( rmRL{1}.Data, 0.33 );
            rmL = compressAndScale( rmRL{2}.Data, 0.33 );
            rm = 0.5 * rmR + 0.5 * rmL;
            spfRL = afeData(3);
            spfR = compressAndScale( spfRL{1}.Data, 0.33 );
            spfL = compressAndScale( spfRL{2}.Data, 0.33 );
            spf = 0.5 * spfL + 0.5 * spfR;
            onsRL = afeData(4);
            onsR = compressAndScale( onsRL{1}.Data, 0.33 );
            onsL = compressAndScale( onsRL{2}.Data, 0.33 );
            ons = 0.5 * onsR + 0.5 * onsL;
            xBlock = [rm, spf, ons];
            x = [x lMomentAlongDim( xBlock, [1,2,3,4], 1, true )];
            for i = 1:obj.deltasLevels
                xBlock = xBlock(2:end,:) - xBlock(1:end-1,:);
                x = [x  lMomentAlongDim( xBlock, [1,2,3,4], 1, true )];
            end
            modRL = afeData(1);
            modR = compressAndScale( modRL{1}.Data, 0.33 );
            modL = compressAndScale( modRL{2}.Data, 0.33 );
            mod = 0.5 * modR + 0.5 * modL;
            mod = reshape( mod, size( mod, 1 ), size( mod, 2 ) * size( mod, 3 ) );
            x = [x lMomentAlongDim( mod, [1,2,3,4], 1, true )];
            for i = 1:obj.deltasLevels
                mod = mod(2:end,:) - mod(1:end-1,:);
                x = [x lMomentAlongDim( mod, [1,2,3,4], 1, true )];
            end
        end
        %% ----------------------------------------------------------------
        
        function outputDeps = getFeatureInternOutputDependencies( obj )
            outputDeps.freqChannels = obj.freqChannels;
            outputDeps.amFreqChannels = obj.amFreqChannels;
            outputDeps.freqChannelsStatistics = obj.freqChannelsStatistics;
            outputDeps.amChannels = obj.amChannels;
            outputDeps.deltasLevels = obj.deltasLevels;
            classInfo = metaclass( obj );
            [classname1, classname2] = strtok( classInfo.Name, '.' );
            if isempty( classname2 ), outputDeps.featureProc = classname1;
            else outputDeps.featureProc = classname2(2:end); end
        end
        %% ----------------------------------------------------------------
        
    end
    
    %% --------------------------------------------------------------------
    methods (Access = protected)
    end
    
end

