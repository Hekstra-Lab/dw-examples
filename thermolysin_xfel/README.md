# Thermolysin

This folder contains instructions and scripts for analyzing anomalous signal from an XFEL dataset of thermolysin (CXIDB, entry 81; Dalton et al. 2022, *Nat. Comm.* 2022, https://doi.org/10.1038/s41467-022-35280-8). Here, we
1. run `careless` with a bivariate prior, for many values of the double-Wilson `r` parameter, and then 
2. inspect merging statistics and anomalous difference peak heights.

We start with MTZ files found in `./unmerged_mtzs`. These were converted from CXIDB entry 81. 

## Configuring the bivariate prior
To run `careless`, we use the script `careless_runs/slurm-dw-array-grid.sh`, which starts a `slurm` batch array job. This job requires `careless_runs/slurm_params.txt`, in which we vary the double-Wilson `r` value across the individual `careless` runs.  To call using slurm: 

```
cd careless_runs
sbatch slurm-dw-array-grid.sh
```

Two flags in `slurm-dw-array-grid.sh` control the behavior of the bivariate prior:

```
CARELESS_ARGS+=(--double-wilson-parents=${DW_LIST}) 
CARELESS_ARGS+=(--double-wilson-r=${DWR_LIST})
```

`DW_LIST` here is `None,0`. This constructs our Bayesian network. The index for each entry refers to the corresponding input MTZ. The value of each entry corresponds to the node that is the ``parent'' of that entry. 
In this case, the 0th node does not have a parent, while the parent of the 1st node is node 0. The unmerged input MTZs are the positive and negative Friedel mates. Graphically, their dependency looks like this:

<img src="anomalous_example_online_v2.png" alt="anomalous example graph" width="160"/>

while `DWR_LIST=0.,0.99`, for example, lists the values of the correlation parameter $r_{DW}$ associated with each edge, so

<img src="anomalous_example_online_v3.png" alt="anomalous example graph" width="160"/>

Since the first edge points to `None`, we set its correlation parameter arbitrarily to 0.

## Further notes
Many `bash` scripts require activating a `conda` environment with `careless` in it. Please take note that you are activating the right `conda` environment! Additionally, the two refinement scripts, `scripts/launch_refinement.sh` and `scripts/launch_refinement_omit.sh`, both require sourcing your copy of `phenix_env.sh`, the environment script that comes with your copy of `phenix`. 

After running `careless`, we evaluate the quality of the `careless` results in the jupyter notebook titled `Inspect_Careless_param_grid.ipynb`. This notebook also plots figures. 

## Folders

- `unmerged_mtzs`: a folder with three unmerged MTZ files. `unmerged.mtz` contains unmerged intensities from CXIDB entry 81. `friedel_{plus,minus}.mtz` are the outputs of `scripts/friedelize.py`, which splits `unmerged.mtz` into F+ and F- half-datasets. 
- `careless_runs`: a folder containing a script for running `careless` as a batch array, as well as the resultant subfolders containing outputs from individual runs of `careless`. 
- `refinement`: a folder containing reference pdb files as well as `phenix` `.eff` files for refinement of `careless` outputs. Additionally, the folder contains an MTZ file with reference `R-free flags`. 
- `scripts`: a folder containing  scripts that are used for processing the output data. Included in `scripts` are:
    - `anomalous_peak_heights.py`: a script called by `run_ccs.sh` that computes the anomalous peak heights at the five anomalous scattering positions. 
    - `friedelize.py`: the script used for splitting `unmerged.mtz` into F+ and F- half-datasets. 
    - `launch_refinement_omit.sh`: a script for refining an omit model against `careless` outputs, where the model's anomalous scatterers have occupancy set to 0. This script is called in `unfriedelize_all.sh`. 
    - `launch_refinement.sh`: a script for refining a model against against `careless` outputs. This script is called in `unfriedelize_all.sh`. 
    - `run_ccs.sh`: a script for calculating CC$_\text{1/2}$, CC$_{\text{pred}}$, CC$_\text{anom}$, and anomalous peak heights for each careless output. This script is called in `Inspect_Careless_param_grid.ipynb`. 
    - `unfriedelize_all.sh`: A script that converts output `careless` MTZ files into downstream readable files. Additionally, this script starts refinement of the `careless` outputs. This script is called in `Inspect_Careless_param_grid.ipynb`. 
    - `unfriedelize.py`: a script for unsplitting MTZ files that have been split by `friedelize.py`. 