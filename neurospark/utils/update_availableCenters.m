%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATE_AVAILABLECENTERS Updates the availability of centers based on a template.
%
%   Inputs:
%   - availableCenters: Binary mask indicating the availability of centers.
%   - centerIndex: Index of the center to update.
%   - template: Struct containing information about the ROI template.
%               It should have the fields:
%               - indices: Indices of the ROI relative to the center.
%               - size: Size of the template.
%               - padding: Padding value for the template.
%
%   Outputs:
%   - availableCenters: Updated binary mask indicating the availability of centers.
%
%   Note: This function extracts the correct indices in the ROI from the template
%   based on the given center index. It then removes the voxels not within the ROI
%   and updates the availability of centers accordingly.

function availableCenters = update_availableCenters(availableCenters, centerIndex, template)

% Extract the correct indices in the ROI from the template
roiIndices = centerIndex + template.indices;

% Convert centerIndex and roiIndices to coordinates
[centerCoord(1), centerCoord(2), centerCoord(3)] = ind2sub(template.size, centerIndex);
[roiCoord(1, :), roiCoord(2, :), roiCoord(3, :)] = ind2sub(template.size, roiIndices);

% Calculate distances between center and ROI coordinates
distances = sqrt(sum((roiCoord - centerCoord').^2, 1));

% Find coordinates outside the padding
nonRoiCoord = distances >= template.padding;

% Remove coordinates not within the ROI
roiCoord(:, nonRoiCoord) = [];

% Convert ROI coordinates back to indices
rmIndices = sub2ind(template.size, roiCoord(1,:), roiCoord(2,:), roiCoord(3,:));

% Update availability of centers by setting corresponding indices to 0
availableCenters(rmIndices) = 0;
end
