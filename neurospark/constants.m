global pkg_folder data_path deriv_path atlas_path paths_nifti ...
    cort_atlas_path cort_labels ...
    subcort_atlas_path subcort_labels;

pkg_folder = fileparts(mfilename('fullpath'));
data_path = fullfile(pkg_folder, 'data');
deriv_path = fullfile(data_path, "derivatives");
atlas_path = fullfile(data_path, 'atlas');
paths_nifti = fullfile(deriv_path, 'sub-02.nii.gz');

cort_atlas_path = fullfile(atlas_path, "HarvardOxford-cort-maxprob-thr25-2mm.nii.gz");
cort_labels = fullfile(atlas_path, 'HarvardOxford-cortical.txt');

subcort_atlas_path = fullfile(atlas_path, "HarvardOxford-sub-maxprob-thr50-2mm.nii.gz");
subcort_labels = fullfile(atlas_path, 'HarvardOxford-Subcortical.txt');
