%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sphere, keepIndices] = extract_roi_from_template(sourceRegion2D, centerIndex, template)
% EXTRACT_ROI_FROM_TEMPLATE Extracts a sphere from a 2D source region based on a template.
%
% Inputs:
% - sourceRegion2D: 2D array representing the source region.
% - centerIndex: Index of the center voxel in the template.
% - template: Structure containing information about the template.
%
% Outputs:
% - sphere: Extracted sphere from the source region.
% - keepIndices: Indices of the voxels within the extracted sphere.

    % Calculate the indices of the ROI based on the template and center index
    roiIndices = centerIndex + template.indices;

    % Calculate the coordinates of the center voxel and ROI voxels
    [centerCoord(1), centerCoord(2), centerCoord(3)] = ind2sub(template.size, centerIndex);
    [roiCoord(1, :), roiCoord(2, :), roiCoord(3, :)] = ind2sub(template.size, roiIndices);

    % Calculate the Euclidean distance from each ROI voxel to the center
    distances = sqrt(sum((roiCoord - centerCoord').^2, 1));
    
    % Remove voxels outside the specified radius
    rm_coord = distances > template.radius;
    roiCoord(:, rm_coord) = [];

    % Convert ROI coordinates back to indices
    keepIndices = sub2ind(template.size, roiCoord(1,:), roiCoord(2,:), roiCoord(3,:));

    % Extract the ROI from the source region based on the calculated indices
    if isnan(sourceRegion2D)
        sphere = nan;
    else
        sphere = sourceRegion2D(keepIndices, :);
        
        % Remove voxels outside the mask region
        rmIndices = find(abs(sphere(:,1)) < 1e-6);
        keepIndices(rmIndices) = [];
        sphere(rmIndices, :) = [];
        sphere = sphere';
    end
end
