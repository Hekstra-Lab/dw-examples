# Nsp3 Mac1 Fragment Screening

This folder contains instructions and scripts for processing an Nsp3 Mac1 fragment screening dataset. To complete the analysis, `rs-booster`(https://github.com/rs-station/rs-booster) must be installed. Here, we
1. run `careless` with a multivariate prior, and for many values of the double-Wilson `r` parameter on 16 holo drug fragment-screening datasets. 
2. inspect CCpred and difference map peak heights.


We start with MTZ files found in `./20221007_unscaled_unmerged`. These were converted from unmerged `.hkl` files generously gifted by Galen Correy, for (Schuller et al. 2021). 

To run `careless`, we use the script `careless_runs/slurm-dw-array-grid.sh`, which starts a `slurm` batch array job. This job requires `careless_runs/slurm_params.txt`, in which we vary the double-Wilson `r` value across the individual `careless` runs.  To call using slurm: 

```
cd careless_runs
sbatch slurm-dw-array-grid.sh
```

Many `bash` scripts require activating a `conda` environment with `careless` in it. Please take note that you are activating the right `conda` environment!  

Then, we evaluate the quality of the `careless` results in the jupyter notebook `Inspect_Careless_param_grid.ipynb`. `Inspect_Careless_param_grid.ipynb` calls the `run_ccs.sh` script that uses `careless` to compute correlation coefficients of careless results, as well as the `make_diffmap.sh` script that uses `reciprocalspaceship` to compute difference maps and peak heights. This notebooks also plots figures. To minimize bias, we refine phases against the reference dataset merged with a univariate prior.  


## Folders and files

- `20221007_unscaled_unmerged`: a folder with sixty-five holo drug fragment screening datasets and one reference drug fragment screening dataset. Each subfolder contains a model as well as several `.mtz` files that have been preprocessed using `scripts/hkl2mtz.sh`, as well as `clean_datasets_compute_diffmaps.ipynb`, a Jupyter notebook that corrects for indexing ambiguities and adds metadata columns to the `.mtz` files in preparation for `careless`. 

- `careless_runs`: a folder containing a script for running `careless` as a batch array, as well as the resultant subfolders containing outputs from individual runs of `careless`. 
- `pymol_dfs`: a folder with pymol inputs and outputs. 
- `scripts`: a folder with scripts and two mtzs. 
    - `DFS_refine_mv.mtz`: an MTZ file with phases refined from `7kqo.pdb` and a dataset merged with a multivariate prior (`careless_runs/merge_20379915_20830_mono_mc1_10k_grid_6/dfs_1.mtz`).
    - `DFS_refine_uv.mtz`: an MTZ file with phases refined from `7kqo.pdb` and a dataset merged with a multivariate prior (`careless_runs/merge_20379918_5300_mono_mc1_10k_grid_2/dfs_1.mtz`). 
    - `hkl2mtz.sh`: a script that uses careless to convert `.hkl` files to `.mtz` files. 
    - `make_diffmap_all.sh`: A script that uses `rs-booster` to compute difference maps given a folder with `careless` runs in it. 
    - `make_diffmap_indiv.sh`: A script that uses `rs-booster` to computes difference maps of a single `careless` run. 
    - `run_ccs_all.sh`: A script that computes CCpred given a folder with `careless` runs in it. 