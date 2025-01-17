classdef BMFAModel < Models.DataScalingModel
    
    %% --------------------------------------------------------------------
    properties (SetAccess = {?ModelTrainers.BMFATrainer, ?ModelTrainers.BGMMmodelSelectTrainer})
        model;

    end
    
    %% --------------------------------------------------------------------
    
    methods (Access = protected)
        
        function [y,score] = applyModelToScaledData( obj, x )
            model1 = obj.model{1};
            model0 = obj.model{2};
            [y, score] = BmfaPredict(x, model1, model0 );

       end
        %% -----------------------------------------------------------------

    end
    
end

