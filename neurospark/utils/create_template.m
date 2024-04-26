%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function template = create_template(volumeShape, radius, padding)
% CREATE_TEMPLATE Generates a spherical template for defining regions of interest (ROIs) in 3D space.
%
% Inputs:
% - volumeShape: 3-element vector specifying the shape (size) of the volume in each dimension.
% - radius: Radius of the spherical ROI.
% - padding: Padding value for the template.
%
% Outputs:
% - template: Structure containing information about the generated template:
%   - indices: Indices of the voxels within the spherical ROI.
%   - size: Size of the template (same as the volume shape).
%   - radius: Radius of the spherical ROI.
%   - padding: Padding value for the template.
%   - maxnbvx: Total number of voxels within the spherical ROI.
% 

    % Create a grid of coordinates
    [X, Y, Z] = ndgrid(1:volumeShape(1), 1:volumeShape(2), 1:volumeShape(3));

    % Compute the center coordinates of the volume
    tmpl_coord = [floor(max(X, [], 'all')/2), floor(max(Y, [], 'all')/2), floor(max(Z, [], 'all')/2)];

    % Compute the distance from each point to the center
    distances = sqrt((X - tmpl_coord(1)).^2 + (Y - tmpl_coord(2)).^2 + (Z - tmpl_coord(3)).^2);

    % Create a binary mask for the spherical ROI
    template_3D = distances <= radius;

    % Get the set list of indices from the template for an ROI centered at 0
    template.indices = find(template_3D)-sub2ind(size(template_3D), ...
        tmpl_coord(1), ...
        tmpl_coord(2), ...
        tmpl_coord(3));

    % Store additional information about the template
    template.size = size(template_3D);
    template.radius = radius;
    template.padding = padding;
    template.maxnbvx = sum(template_3D, 'all');
end
