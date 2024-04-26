# NeuroSpark
A matlab tool for efficient searchlight analysis

NeuroSpark is a versatile MATLAB toolbox designed for conducting fast searchlight analyses on neuroimaging data. It facilitates the extraction of spheres from arbitrary regions of interest the performance of searchlight analyses.

## Features

  - Efficient Searchlight Analysis: Conduct searchlight analyses on neuroimaging data quickly and efficiently.
  - Customizable ROIs: Define and load predefined ROIs using flexible pattern matching.
  - Modular Architecture: Easy integration of custom analysis methods and additional metadata.
  - Flexible Options: Customize analysis parameters such as padding for smoothing regions and cortex.

## TODO:

  - [x] init && working! :rocket:
  - [ ] add fancy images to readme
  - [ ] add drawing nifti images functions to visualize regions and overall results

## Installation

Clone the repository to your local machine:

```bash

git clone https://github.com/mlionello/NeuroSpark.git
```

## Setup
Configure constants.m according to where your atlas, and derivatives are placed

## Usage
Use the example neurospark.m function to perform searchlight analyses. Customize the analysis parameters and options as needed.

```matlab

[results, center_indices, full_indices] = neurospark(roi1_pattern, roi2_pattern, analyser, mdata, opts);

[results, center_indices, full_indices] = neurospark(["V1", "V4"], ["premtoro"], @perform_lr_on_searchlight, 'searchlight_radius', 3, 'searchlight_padding', 1, 'targetPropInVx', 0.7);

[results, center_indices, full_indices] = neurospark(["attention"], "allbrain", @perform_svm_on_searchlight, struct('reduction_method', @max));
```

## Documentation
Refer to the function headers and comments within the codebase for detailed usage instructions.

## Contributions
Contributions are welcome! If you find any bugs or have suggestions for improvement, please open an issue or submit a pull request.
