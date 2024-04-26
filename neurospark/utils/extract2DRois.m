%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXTRACT2DROIS Extracts 2D ROIs from a 3D mask and a corresponding 4D NIfTI image.
%
%   Inputs:
%   - mask: 3D binary mask representing the region of interest (ROI).
%   - nifti_image: 4D NIfTI image.
%
%   Outputs:
%   - roi2D: 2D matrix containing the extracted ROIs. Each column represents a 2D ROI.
%   - indices: Linear indices of the voxels within the ROI in the original 3D mask.
%
%   Note: The function extracts 2D ROIs from the 4D NIfTI image corresponding to
%   the non-zero voxels in the 3D mask. The extracted ROIs are stored in columns
%   of the roi2D matrix, and indices stores the linear indices of the voxels
%   within the ROI in the original 3D mask.

function [roi2D, indices] = extract2DRois(mask, nifti_image)

    % Find linear indices of non-zero voxels in the mask
    indices = find(mask);
    
    % Initialize matrix to store 2D ROIs
    roi2D = nan(size(nifti_image, 4), length(indices));
    
    % Loop through each voxel index in the mask
    for indx = 1:length(indices)
        % Extract the corresponding 2D ROI from the 4D NIfTI image
        roi2D(:, indx) = nifti_image(indices(indx):numel(mask):end);
    end
end
