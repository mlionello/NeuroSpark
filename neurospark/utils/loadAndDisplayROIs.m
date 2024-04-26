%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [roi1_id, roi1_label, roi2_id, roi2_label] = loadAndDisplayROIs(roi1_pattern, cort_labels, roi2_pattern, subcort_labels)
%LOADANDDISPLAYROIS Loads and displays regions of interest (ROIs).
%   This function loads ROIs based on provided patterns and displays their IDs.
%   
%   Inputs:
%   - roi1_pattern: Cell array of patterns for the first ROI.
%   - cort_labels: File path for cortical labels.
%   - roi2_pattern: Cell array of patterns for the second ROI.
%   - subcort_labels: File path for subcortical labels.
%
%   Outputs:
%   - roi1_id: IDs of the first ROI.
%   - roi1_label: Atlas labels of the first ROI.
%   - roi2_id: IDs of the second ROI.
%   - roi2_label: Atlas labels of the second ROI.
%
%   Note: If an error occurs during processing, empty arrays will be returned
%   for all outputs.
    
    try
        % Extract ROI IDs and labels for the first ROI
        [roi1_id, roi1_label] = extractROIIds(roi1_pattern, cort_labels, subcort_labels);
        % Display ROI IDs for the first ROI
        displayROIIds(roi1_pattern, roi1_id);
        
        % Check if the second ROI pattern is "allbrain"
        if matches(roi2_pattern, "allbrain")
            % If yes, set roi2_id to nan and roi2_label to "allbrain"
            roi2_id = nan;  
            roi2_label = "allbrain";
            fprintf("vs all brain\n")
        else
            % Extract ROI IDs and labels for the second ROI
            [roi2_id, roi2_label] = extractROIIds(roi2_pattern, cort_labels, subcort_labels);
            % Display ROI IDs for the second ROI
            displayROIIds(roi2_pattern, roi2_id);
        end
    catch exception
        fprintf('Error occurred: %s\n', exception.message);
        roi1_id = [];
        roi1_label = [];
        roi2_id = [];
        roi2_label = [];
    end
end


function [roi_id_out, roi_label_out] = extractROIIds(pattern, CORT_LABELS, SUBCORT_LABELS)
    % Initialize outputs
    roi_label_out = [];
    roi_id_out = [];
    
    % Iterate through each pattern
    for i = 1:length(pattern)

        % Split the pattern into type and label
        split_pattern = strsplit(pattern{i}, ':');
        extracted_pattern = split_pattern{2};
        
        % Extract ROI IDs and labels based on type (cort/sub)
        if strcmp(split_pattern{1}, 'cort')
            [roi_id, roi_label] = extractROIIds_interate_atlas(CORT_LABELS, extracted_pattern);

        elseif strcmp(split_pattern{1}, 'sub')
            [roi_id, roi_label] = extractROIIds_interate_atlas(SUBCORT_LABELS, extracted_pattern);

        else
            error('Invalid ROI type specified.');
        end
        
        roi_label_out = [roi_label_out, strcat(split_pattern{1}+":", roi_label)];
        roi_id_out = [roi_id_out, roi_id];
    end
end


function [roi_id, roi_label] = extractROIIds_interate_atlas(file_path, pattern)
    % Initialize outputs
    roi_id = [];
    roi_label = {};
    
    fid = fopen(file_path, 'r');
    if fid == -1
        error('Could not open file: %s', file_path);
    end
    
    % Iterate through each line in the file
    tline = fgetl(fid);
    while ischar(tline)

        % Extract ID from the current line
        current_id = sscanf(tline, '%f');
        last_string = strsplit(tline);
        last_string = last_string{end};
        
        % Check if the pattern matches the current line
        if any(contains(lower(last_string), lower(pattern)))

            % Add ID to the output
            roi_id = [roi_id, int32(current_id(1))];

            % Add label to the output
            roi_label{end+1} = last_string;
        end
        
        tline = fgetl(fid);
    end
    
    fclose(fid);
end
