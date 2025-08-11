# PYP

This folder contains instructions and scripts for processing a time-resolved photactive yellow protein (PYP) dataset. Here, we
1. run `careless` with a bivariate prior, for many values of the double-Wilson `r` parameter, and then 
2. inspect merging statistics and time-resolved differences.

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

`DW_LIST` here is `None,0`. This constructs our graph relating datasets. The index for each entry refers to the corresponding input MTZ. The value of each entry corresponds to the node that is the ``parent'' of that entry. 
In this case, the 0th node does not have a parent, while the parent of the 1st node is node 0. Graphically, that looks like this,

<img src="figures/PYP_example_online_v2.png" alt="PYP example graph" width="160"/>

while `DWR_LIST=0.,0.99`, for example, lists the values of the correlation parameter $r_{DW}$ associated with each edge, so

<img src="figures/PYP_example_online_v3.png" alt="PYP example graph" width="160"/>

Since the first edge points to `None`, we set its correlation parameter arbitrarily to 0.

## Further notes
We start with MTZ files found in `./unmerged_mtzs`. These were converted from `precognition` files provided by Vukica Srajer, for (Dalton et al. *Nat. Comm.* 2022, https://doi.org/10.1038/s41467-022-35280-8). 

Many `bash` scripts require activating a `conda` environment with `careless` in it. Please take note that you are activating the right `conda` environment!  

Then, we evaluate the quality of the `careless` results in two jupyter notebooks, `Inspect_Careless_param_grid.ipynb` and `PYP_diff_map_corr.ipynb`. `Inspect_Careless_param_grid.ipynb` calls the `run_ccs.sh` script for computing correlation coefficients of careless results. Both of these notebooks also plots figures. 


## Folders

- `unmerged_mtzs`: a folder with two unmerged MTZ files containing unmerged reflections from PYP Laue diffraction data. One MTZ contains `off` data and the other, `2ms` after laser irradiation. 
- `merged_mtzs`: output of `Inspect_Careless_param_grid.ipynb` containing difference maps for each `careless` run.
- `ref`: reference MTZ files and pdb files from (Dalton et al. 2022), from files processed by DH using `phenix`, and PDB entries 1TSO and 2PHY. 
- `careless_runs`: a folder containing a script for running `careless` as a batch array, as well as the resultant subfolders containing outputs from individual runs of `careless`. 
- `pymol`: inputs to, and outputs from pymol for visualizing difference maps. 
- `figures`: plot outputs from Jupyter notebooks. 
