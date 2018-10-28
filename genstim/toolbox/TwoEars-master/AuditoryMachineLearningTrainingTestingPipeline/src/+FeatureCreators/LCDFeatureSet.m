classdef LCDFeatureSet < FeatureCreators.Base
% Largest Common Denominator feature set Specifies a feature set consisting of:
%   see LCDFeatureSet.getAFErequests()

    %% --------------------------------------------------------------------
    properties (SetAccess = private)
        deltasLevels;
    end
    
    %% --------------------------------------------------------------------
    methods (Static)
        function commonParams = getCommonAFEParams( )
            commonParams = {...
                'pp_bNormalizeRMS', true, ...   % default is 0
                'pp_intTimeSecRMS', 4, ...      % default is 500E-3
                'pp_bBinauralRMS', true, ...    % default is true
                'fb_type', 'gammatone', ...
                'fb_lowFreqHz', 80, ...
                'fb_highFreqHz', 8000, ...
                'ihc_method', 'halfwave', ... % stream segr. uses 'dau'
                'ild_wSizeSec', 20E-3, ...  % DnnLoc uses 20E-3, stream segr. uses 25E-3
                'ild_hSizeSec', 10E-3, ...
                'rm_wSizeSec', 20E-3, ... % DnnLoc uses 20E-3, identification uses 25E-3
                'rm_hSizeSec', 10E-3, ... % DO NOT CHANGE -- important for gabor filters
                'rm_scaling', 'power', ... % DnnLoc uses power, identification uses magnitude
                'rm_decaySec', 8E-3, ...
                'cc_wSizeSec', 20E-3, ... % dnnLocKs uses 20E-3, stream segr. uses 25E-3
                'cc_hSizeSec', 10E-3, ... % dnnLocKs uses 10E-3, stream segr. uses 10E-2
                'cc_wname', 'hann' ...,
                'cc_maxDelaySec', 1.1E-3,... % default is 1.1E-3, stream segregation will use 1.1E-3 as well
                };
        end
    end
    
    %% --------------------------------------------------------------------
    methods (Access = public)
        
        function obj = LCDFeatureSet( )
            obj = obj@FeatureCreators.Base();
        end
        %% ----------------------------------------------------------------

        function afeRequests = getAFErequests( obj )
            commonParams = FeatureCreators.LCDFeatureSet.getCommonAFEParams();
            afeRequests{1}.name = 'amsFeatures';
            afeRequests{1}.params = genParStruct( ...
                commonParams{:}, ...
                'fb_nChannels', 16, ... % Use same value as ratemaps to compute IHC once?
                'ams_fbType', 'log', ...
                'ams_nFilters', 8, ...
                'ams_lowFreqHz', 2, ...
                'ams_highFreqHz', 256', ...
                'ams_wSizeSec', 128e-3, ...
                'ams_hSizeSec', 32e-3 ...
                );
            afeRequests{2}.name = 'spectralFeatures';
            afeRequests{2}.params = genParStruct( ...
                commonParams{:}, ...
                'fb_nChannels', 32 ...
                );
            afeRequests{3}.name = 'ratemap';
            afeRequests{3}.params = genParStruct( ...
                commonParams{:}, ...
                'fb_nChannels', 32 ...
                );
            afeRequests{4}.name = 'onsetStrength'; % same as Nsrcs set
            afeRequests{4}.params = genParStruct( ...
                commonParams{:}, ...
                'fb_nChannels', 32);
            afeRequests{5}.name = 'crosscorrelation'; % same as dnnLocKs
            afeRequests{5}.params = genParStruct( ...
                commonParams{:}, ...
                'fb_nChannels', 32);
            afeRequests{6}.name = 'duet'; % same as Nsrcs set
            afeRequests{6}.params = genParStruct( ...
                'duet_wSTFTSec', 0.02,...
                'duet_wDUETSec', (1/2),...
                'duet_hDUETSec', (1/6));
            afeRequests{7}.name = 'itd'; % same as segmentationKs
            afeRequests{7}.params = genParStruct( ...
                commonParams{:}, ...
                'fb_nChannels', 32);
            afeRequests{8}.name = 'ild'; % same as dnnLocKs
            afeRequests{8}.params = genParStruct(...
                commonParams{:}, ...
                'fb_nChannels', 32 ...
                );
            %afeRequests{9}.name = 'gabor';
            %afeRequests{9}.params = genParStruct( ...
            %    commonParams{:}, ...
            %    'fb_nChannels', 24 ... % independent of everything else, only used for identification
            %    );
        end
        %% ----------------------------------------------------------------

        function x = constructVector( obj )
            % constructVector for each feature: compress, scale, average
            %   over left and right channels, construct individual feature names
            %   returned flattened feature vector for entire block
            %   The AFE data is indexed according to the order in which the requests
            %   where made
            % 
            %   See getAFErequests
            assert( false );
            % afeIdx 9: gabor
%             gbR = obj.makeBlockFromAfe( 9, 1, ...
%                 @(a)(compressAndScale( a.Data, 0.33, @(x)(median( x(x>0.01) )), 0 )), ...
%                 {@(a)(a.Name), @(a)([num2str(size(a.Data,2)) '-ch']), @(a)(a.Channel)}, ...
%                 {'t'}, ...
%                 {@(a)(strcat('ft#', a.fList))} );
%             gbL = obj.makeBlockFromAfe( 9, 2, ...
%                 @(a)(compressAndScale( a.Data, 0.33, @(x)(median( x(x>0.01) )), 0 )), ...
%                 {@(a)(a.Name), @(a)([num2str(size(a.Data,2)) '-ch']), @(a)(a.Channel)}, ...
%                 {'t'}, ...
%                 {@(a)(strcat('ft#', a.fList))} );
%             gb = obj.combineBlocks( @(b1,b2)(0.5*b1+0.5*b2), 'LRmean', gbR, gbL );
            % afeIdx 2: spectralFeatures
            spfR = obj.makeBlockFromAfe( 2, 1, ...
                @(a)(compressAndScale( a.Data, 0.33 )), ...
                {@(a)(a.Name),[num2str(obj.freqChannelsStatistics) '-ch'], ...
                @(a)(a.Channel)}, ...
                {'t'}, ...
                {@(a)(a.fList)} );
            spfL = obj.makeBlockFromAfe( 2, 2, ...
                @(a)(compressAndScale( a.Data, 0.33 )), ...
                {@(a)(a.Name),[num2str(obj.freqChannelsStatistics) '-ch'],...
                @(a)(a.Channel)}, ...
                {'t'}, ...
                {@(a)(a.fList)} );
            spf = obj.combineBlocks( @(b1,b2)(0.5*b1+0.5*b2), 'LRmean', spfR, spfL );
            xb = obj.concatBlocks( 2, gb, spf );
            x = obj.block2feat( xb, ...
                @(b)(lMomentAlongDim( b, [1,2,3], 1, true )), ...
                2, @(idxs)(sort([idxs idxs idxs])),...
                {{'1.LMom',@(idxs)(idxs(1:3:end))},...
                 {'2.LMom',@(idxs)(idxs(2:3:end))},...
                 {'3.LMom',@(idxs)(idxs(3:3:end))}} );
            for ii = 1:obj.deltasLevels
                xb = obj.transformBlock( xb, 1, ...
                    @(b)(b(2:end,:) - b(1:end-1,:)), ...
                    @(idxs)(idxs(1:end-1)),...
                    {[num2str(ii) '.delta']} );
                xtmp = obj.block2feat( xb, ...
                    @(b)(lMomentAlongDim( b, [1,2], 1, true )), ...
                    2, @(idxs)(sort([idxs idxs])),...
                    {{'1.LMom',@(idxs)(idxs(1:4:end))},...
                     {'2.LMom',@(idxs)(idxs(2:4:end))}} );
                x = obj.concatFeats( x, xtmp );
            end
            % afeIdx 1: amsFeatures and generate corresponding feature names
            modR = obj.makeBlockFromAfe( 1, 1, ...
                @(a)(compressAndScale( a.Data, 0.33 )), ...
                {@(a)(a.Name), @(a)([num2str(numel(a.cfHz)) '-ch']), @(a)(a.Channel)}, ...
                {'t'}, ...,
                {@(a)(strcat('f', arrayfun(@(f)(num2str(f)), a.cfHz,'UniformOutput', false)))}, ...
                {@(a)(strcat('mf', arrayfun(@(f)(num2str(f)), a.modCfHz,'UniformOutput', false)))} );
            modL = obj.makeBlockFromAfe( 1, 2, ...
                @(a)(compressAndScale( a.Data, 0.33 )), ...
                {@(a)(a.Name), @(a)([num2str(numel(a.cfHz)) '-ch']), @(a)(a.Channel)}, ... % groups
                {'t'}, ... % varargin: time index
                {@(a)(strcat('f', arrayfun(@(f)(num2str(f)), a.cfHz,'UniformOutput', false)))}, ... % varargin: freq. bins
                {@(a)(strcat('mf', arrayfun(@(f)(num2str(f)), a.modCfHz,'UniformOutput', false)))} ); % vararing: modulation frequencies
            % average between right and left channels
            mod = obj.combineBlocks( @(b1,b2)(0.5*b1+0.5*b2), 'LRmean', modR, modL );
            mod = obj.reshapeBlock( mod, 1 ); % flatten
            % append l-moments
            x = obj.concatFeats( x, obj.block2feat( mod, ...
                @(b)(lMomentAlongDim( b, [1,2], 1, true )), ...
                2, @(idxs)(sort([idxs idxs])),...
                {{'1.LMom', @(idxs)(idxs(1:2:end))},...
                 {'2.LMom', @(idxs)(idxs(2:2:end))}} ) );
            % append first derivative
            for ii = 1:obj.deltasLevels
                mod = obj.transformBlock( mod, 1, ...
                    @(b)(b(2:end,:) - b(1:end-1,:)), ...
                    @(idxs)(idxs(1:end-1)),...
                    {[num2str(ii) '.delta']} );
                x = obj.concatFeats( x, obj.block2feat( mod, ...
                    @(b)(lMomentAlongDim( b, [1,2], 1, true )), ...
                    2, @(idxs)(sort([idxs idxs])),...
                    {{'1.LMom', @(idxs)(idxs(1:3:end))},...
                     {'2.LMom', @(idxs)(idxs(2:3:end))}} ) );
            end
        end
        %% ----------------------------------------------------------------
        
        function outputDeps = getFeatureInternOutputDependencies( obj )
            outputDeps.deltasLevels = obj.deltasLevels;
            classInfo = metaclass( obj );
            [classname1, classname2] = strtok( classInfo.Name, '.' );
            if isempty( classname2 ), outputDeps.featureProc = classname1;
            else outputDeps.featureProc = classname2(2:end); end
            outputDeps.v = 1;
        end
        %% ----------------------------------------------------------------
        
    end
    
    %% --------------------------------------------------------------------
    methods (Access = protected)
    end
    
end

