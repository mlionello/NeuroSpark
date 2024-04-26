%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Matteo Lionello
%%% github.com/mlionello/NeuroSpark
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SMOOTHED_MASK it does not work as expectedd, the output mask will be wider
% then the number of voxel set in NN_vx

function smoothed_mask = smooth_mask(mask, NN_vx)

    kernel_size = NN_vx*2 + 1;
    kernel = ones(kernel_size, kernel_size, kernel_size);
    
    % Pad the mask matrix to handle border smoothing
    pad_size = NN_vx;
    padded_mask = padarray(mask, [pad_size, pad_size, pad_size]);
    
    % Perform convolution
    smoothed_mask = convn(padded_mask, kernel, 'same');
    
    % Threshold the result to get a binary mask
    smoothed_mask = smoothed_mask > 0;
    
    % Remove the padded border
    smoothed_mask = smoothed_mask((1+NN_vx):end-NN_vx, ...
        (1+NN_vx):end-NN_vx, ...
        (1+NN_vx):end-NN_vx);
end
