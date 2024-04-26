%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATEMASKS Creates masks for regions of interest (ROIs) based on the provided IDs and labels.
%
% Inputs:
% - roi1_id: ID of the first ROI.
% - roi2_id: ID of the second ROI.
% - atlas_path: Path to the atlas directory.
% - cort_atlas_path: Path to the cortical atlas file.
% - subcort_atlas_path: Path to the subcortical atlas file.
% - smooth_regions: Flag indicating whether to apply smoothing to the regions.
% - smooth_cortex: Flag indicating whether to apply smoothing to the cortex.
% - roi1_label: Label of the first ROI.
% - roi2_label: Label of the second ROI.
%
% Outputs:
% - masks: Struct containing generated masks for the ROIs and cortical/subcortical regions.

function masks = createMasks(roi1_id, roi2_id, ...
        atlas_path, cort_atlas_path, subcort_atlas_path, ...
        smooth_regions, smooth_cortex, ...
        roi1_label, roi2_label)

    % Read cortical and subcortical atlas files
    cort_atlas = niftiread(cort_atlas_path);
    subcort_atlas = niftiread(subcort_atlas_path);

    % Extract masks for ROI 1 and ROI 2
    roi1_mask = extract_mask(roi1_label, cort_atlas, subcort_atlas, roi1_id, smooth_regions);
    if ~matches(roi2_label, "allbrain")
        roi2_mask = extract_mask(roi2_label, cort_atlas, subcort_atlas, roi2_id, smooth_regions);
    else
        roi2_mask = niftiread(fullfile(atlas_path, "allbrain_mask.nii.gz"));
    end

    % Create cortical and subcortical masks
    corticalMask = cort_atlas;
    subCorticalMask = subcort_atlas;
    corticalMask(corticalMask ~= 0) = 1;
    subCorticalMask(subCorticalMask ~= 0) = 1;

    % Combine cortical and subcortical masks
    cortAndSubMaks = corticalMask + subCorticalMask;
    cortAndSubMaks(cortAndSubMaks > 1) = 1;
    
    % Apply smoothing to the combined mask if specified
    if smooth_cortex
        cortAndSubMaks = smooth_mask(cortAndSubMaks, smooth_cortex);
    end

    % Store the masks in a struct
    masks = struct('roi1_mask', roi1_mask, 'roi2_mask', roi2_mask, 'corticalMask', corticalMask, ...
        'subCorticalMask', subCorticalMask, ...
        'cortAndSubMaks', cortAndSubMaks);
end

function mask = extract_mask(pattern, cort_atlas, subcort_atlas, roi_id, smooth_regions)
% EXTRACT_MASK Extracts a mask for a region of interest (ROI) based on the provided pattern and atlas.
%
% Inputs:
% - pattern: Pattern defining the ROI.
% - cort_atlas: Cortical atlas data.
% - subcort_atlas: Subcortical atlas data.
% - roi_id: ID of the ROI.
% - smooth_regions: Flag indicating whether to apply smoothing to the regions.
%
% Outputs:
% - mask: Mask for the ROI.

    % Initialize mask
    mask = zeros(size(cort_atlas));
    
    % Iterate over each pattern
    for i = 1:length(pattern)
        % Split pattern into type and label
        split_pattern = strsplit(pattern{i}, ':');
        if strcmp(split_pattern{1}, 'cort')
            % Add cortical regions to the mask
            mask = mask | ismember(cort_atlas, single(roi_id(i)));
        else
            % Add subcortical regions to the mask
            mask = mask | ismember(subcort_atlas, single(roi_id(i)));
        end
    end
    
    % Apply smoothing to the mask if specified
    if smooth_regions
        mask = smooth_mask(mask, smooth_regions);
    end
end
