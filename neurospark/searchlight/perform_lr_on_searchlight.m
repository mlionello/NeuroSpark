%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERFORM_LR_ON_SEARCHLIGHT Performs linear regression analysis between two ROIs.
%
% Inputs:
% - targetRoi: Target ROI data.
% - sourceRoi: Source ROI data.
% - mdata: Additional data placeholder.
%
% Outputs:
% - results: Results of the linear regression analysis.

function results = perform_lr_on_searchlight(sourceRoi, targetRoi, mdata)
    if ~isfield(mdata, 'reduction_method')
        mdata.reduction_method = @mean;
    end

    Y = mdata.reduction_method(targetRoi, 2);

    % Perform linear regression
    [b, bint, r, ~, stats] = regress(Y, [ones(size(sourceRoi, 1), 1), sourceRoi]);

    % Store results in a struct
    results.b = b;
    results.bint = bint;
    results.r = r;
    results.stats = stats;
end