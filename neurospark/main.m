%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [results, center_indices, full_indices] = main(roi1_pattern, roi2_pattern, analyser, mdata, opts)
% This script is designed to compute masks and perform a fast(!) searchlight 
% analysis on neuroimaging data. It loads predefined regions of interest,
% creates masks based on these regions, applies the masks to NIfTI images,
% extracts relevant data, and then conducts a searchlight analysis comparing 
% regions of interest within the data.
%
% Arguments:
% - roi1_pattern: Pattern for the first region of interest.
% - roi2_pattern: Pattern for the region of interest over which to perform the searchlight analysis. Default is "allbrain".
% - analyser: Function handle for the analysis method. Default performs linear regression.
% - mdata: Additional metadata for analysis.
% - opts: Optional structure containing additional options.
%   - smooth_regions_padding: Padding for smoothing regions. Default is 0.
%   - smooth_cortex_padding: Padding for smoothing cortex. Default is 0.
%
% Returns:
% - results: Results of the searchlight analysis.
% - center_indices: Indices of the centers of the searchlight spheres.
% - full_indices: Indices of the voxels in each sphere.

arguments
roi1_pattern;
roi2_pattern = "allbrain";
analyser = @perform_lr_on_searchlight;
mdata = struct();
opts.smooth_regions_padding = 0;
opts.smooth_cortex_padding = 0;
end

% Add necessary paths and import constants
addpath ../; constants;

% import support functions;
addpath ./utils/ ./searchlight

global paths_nifti atlas_path ...
cort_atlas_path cort_labels ...
subcort_atlas_path subcort_labels; % as defined in constants.m

% Load and display regions of interest
[roi1_id, roi1_label, roi2_id, roi2_label] = loadAndDisplayROIs(...
    roi1_pattern, cort_labels, roi2_pattern, subcort_labels);

% Create masks based on loaded regions of interest
masks = createMasks( roi1_id, roi2_id, atlas_path, ...
    cort_atlas_path, subcort_atlas_path, opts.smooth_regions_padding, ...
    opts.smooth_cortex_padding, roi1_label, roi2_label);

% Create a template based on the size of the masks
template = create_template(size(masks.roi1_mask), 0, 1);

% Load NIfTI image
nifti_image = niftiread(paths_nifti);

% Apply the target region mask to the NIfTI image
targetRoi = nifti_image .* masks.targetRegionMask;

% Convert the masked region to 2D
targetRoi2D = reshape(targetRoi, [], size(targetRoi, 4));

% Extract 2D regions of interest from the source region mask
sourceRegion2D = extract2DRois(masks.sourceRegionMask, nifti_image);

% Perform searchlight analysis on the source and target regions
[results, center_indices, full_indices] = searchlight(sourceRegion2D, ...
    targetPropInVx, targetRegionMask, targetRoi2D, ...
    template, analyser, mdata);
end
