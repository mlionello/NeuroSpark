function results = perform_svm_on_searchlight(targetRoi, sourceRoi, mdata)
    % perform canonical correlation between the two ROIs and
    kernel = mdata.kernel;
    training_split = mdata.training_split; % cell N X 2

    Y = mdata.reduction_method(targetRoi);

    for fit_i = 1:size(training_split, 1)
        train_indx = training_split(fit_i, 1);
        test_indx = training_split(fit_i, 2);

        mdl{fit_i} = fitrsvm(sourceRoi(train_indx, :), Y(train_indx, :), 'KernelFunction', kernel);

        ytr_hat = mdl{fit_i}.predict(sourceRoi(train_indx, :));
        r2_tr{fit_i} = corrcoef(Y(train_indx, :), ytr_hat).^2;
        ytst_hat = mdl{fit_i}.predict(sourceRoi(test_indx, :));
        r2_tst{fit_i} = corrcoef(Y(test_indx, :), ytst_hat).^2;
    end

    results.mdl = mdl;
    results.r2_tst = r2_tst;
    results.r2_tr = r2_tr;
end
