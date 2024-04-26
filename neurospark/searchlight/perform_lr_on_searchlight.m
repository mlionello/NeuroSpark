function results = perform_lr_on_searchlight(targetRoi, sourceRoi, mdata)
% PERFORM_LR_ON_SEARCHLIGHT Performs linear regression analysis between two ROIs.
%
% Inputs:
% - targetRoi: Target ROI data.
% - sourceRoi: Source ROI data.
% - mdata: Additional data placeholder (unused).
%
% Outputs:
% - results: Results of the linear regression analysis.

    % Perform linear regression
    [b, bint, r, ~, stats] = regress(targetRoi, [ones(size(sourceRoi, 1), 1), sourceRoi]);

    % Store results in a struct
    results.b = b;
    results.bint = bint;
    results.r = r;
    results.stats = stats;
end