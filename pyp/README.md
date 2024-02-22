# PYP

This folder contains instructions and scripts for processing a time-resolved PYP dataset. Here, we
1. run `careless` with a bivariate prior, for many values of the double-Wilson `r` parameter, and then 
2. inspect merging statistics and time-resolved differences.


We start with MTZ files found in `./unmerged_mtzs`. These were converted from `precognition` files gifted by Vukica Srajer, for (Dalton et al. 2022). 

To run `careless`, we use the script `careless_runs/slurm-dw-array-grid.sh`, which starts a `slurm` batch array job. This job requires `careless_runs/slurm_params.txt`, in which we vary the double-Wilson `r` value across the individual `careless` runs.  To call using slurm: 

```
cd careless_runs
sbatch slurm-dw-array-grid.sh
```

Many `bash` scripts require activating a `conda` environment with `careless` in it. Please take note that you are activating the right `conda` environment!  

Then, we evaluate the quality of the `careless` results in two jupyter notebooks, `Inspect_Careless_param_grid.ipynb` and `PYP_diff_map_corr.ipynb`. `Inspect_Careless_param_grid.ipynb` calls the `run_ccs.sh` script for computing correlation coefficients of careless results. Both of these notebooks also plots figures. 


## Folders

- `unmerged_mtzs`: a folder with two unmerged MTZ files containing unmerged reflections from PYP Laue diffraction data. One MTZ contains `off` data and the other, `2ms` after laser irradiation. 
- `merged_mtzs`: output of `Inspect_Careless_param_grid.ipynb` containing difference maps for each `careless` run.
- `ref`: reference MTZ files and pdb files from (Dalton et al. 2022), from files processed by DH using `phenix`, and PDB entries 1TSO and 2PHY. 
- `careless_runs`: a folder containing a script for running `careless` as a batch array, as well as the resultant subfolders containing outputs from individual runs of `careless`. 
- `pymol`: inputs to, and outputs from pymol for visualizing difference maps. 
- `figures`: plot outputs from Jupyter notebooks. 