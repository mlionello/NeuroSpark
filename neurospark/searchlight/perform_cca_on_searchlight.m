function results = perform_cca_on_searchlight(targetRoi, sourceRoi, mdata)
    % perform canonical correlation between the two ROIs and
    warning('off')
    [A, B, r, ~, ~, ~] = canoncorr(targetRoi, sourceRoi);
    results.A = A;
    results.B = B;
    results.r = r;
    warning('on')
end
