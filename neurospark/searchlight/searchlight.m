%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs a searchlight analysis on source and target regions.
%
% Inputs:
% - sourceRoi: 2D array representing the source region.
% - targetPropInVx: Proportion of voxels in the target region.
% - targetRegionMask: Mask for the target region.
% - targetRegion2D: 2D representation of the target region.
% - targetRoiTemplate: Template for the target ROI.
% - analyser: Function handle for the analysis method.
% - mdata: Additional metadata for analysis.
%
% Outputs:
% - results: Results of the searchlight analysis.
% - center_indices: Indices of the centers of the searchlight spheres.
% - full_indices: Full indices of the target ROI.

function [results, center_indices, full_indices] = searchlight(sourceRoi, ...
    targetPropInVx, targetRegionMask, targetRegion2D, ...
    targetRoiTemplate, analyser, mdata)

    % Initialize variables
    availablecentres = reshape(targetRegionMask, [], 1);
    init_availablereg = sum(availablecentres, 'all');
    cr = "";
    init_available_centers_list = find(targetRegionMask);
    results = cell(numel(init_available_centers_list), 1);
    center_indices = zeros(numel(init_available_centers_list), 1);
    full_indices = cell(numel(init_available_centers_list), 1);
    tic;
    
    % Iterate over target ROI candidate centers
    for cursor = 1: numel(init_available_centers_list)
        targetRoiCenter = init_available_centers_list(cursor);

        % Check if targetRoiCenter is available
        if ~availablecentres(targetRoiCenter)
            continue
        end

        % Extract a sphere from the target ROI
        [targetRoi, full_indices_tmp] = extract_roi_from_template(targetRegion2D, targetRoiCenter, targetRoiTemplate);
        
        % Check if target ROI size fits the given percentage of voxel
        % belonging to the mask
        if size(targetRoi, 2) < int32(targetPropInVx*targetRoiTemplate.maxnbvx)
            continue
        end

        % Display progress
        port_undone = sum(availablecentres, 'all')/init_availablereg;
        port_done = 1-port_undone;
        msg = compose("\tprocessing targetRoi: %.1f/100 eta: %s elapsed: %s", ...
            100*port_done, string(duration(0,0,toc*port_undone/port_done)), ...
            string(duration(0,0,toc)));
        fprintf(cr + msg);
        cr = repmat('\b', 1, strlength(msg));

        % Perform analysis
        results{cursor} = analyser(sourceRoi, targetRoi, mdata); %TODO: support for svm!!
        center_indices(cursor) = targetRoiCenter;
        full_indices{cursor} = full_indices_tmp;

        % Update available centers
        availablecentres = update_availableCenters(availablecentres, ...
            targetRoiCenter, targetRoiTemplate); %this is why i cannot move to parfor

    end
    fprintf('\n')

    % Remove zero-initialized elements
    keep_indices = find(center_indices); % center_indices is initialized with zeros
    center_indices = center_indices(keep_indices);
    full_indices = full_indices(keep_indices);
    results = results(keep_indices);

end
