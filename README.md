# dw-examples

This folder contains four examples of merging crystallographic intensities with a bivariate prior:

- [time-resolved Laue crystallography of the photoactive yellow protein](pyp/README.md)
- [anomalous diffraction from serial XFEL crystallography of thermolysin](thermolysin_xfel/README.md)
- [anomalous diffraction from Laue crystallography of NaI-soaked lysozyme](lysozyme/README.md)
- [fragment screening monochromatic data of Nsp3 Mac1](dfs/README.md)  

Every example includes scripts to run `careless` as well as to analyze the outputs in order to reproduce the figures in the double-Wilson manuscript. For every example, there is a `README.md` that describes the contents of each example folder.  

## requirements 

To run much of the scripts and notebooks in this repository, [Careless](https://github.com/rs-station/careless) and [rs-booster](https://github.com/rs-station/rs-booster) must be installed. See both repositories for installation instructions. Many scripts activate a conda environment with Careless installed, e.g. [run_ccs.sh](pyp/run_ccs.sh) in the `pyp` folder:

```
#please indicate your desired careless environment here!
eval "$(conda shell.bash hook)"
conda activate careless
```
Please change the name of the conda environment as needed. 

Additionally, some scripts require sourcing Phenix, e.g. [launch_refinement.sh](thermolysin_xfel/scripts/launch_refinement.sh) in the `thermolysin_xfel` folder: 


```
# source your copy of phenix here!
source ../../../../../../phenix-1.20.1-4487/phenix_env.sh
```
Please change the path of the phenix environment file as needed. 

Finally, all jobs were run on a computing cluster, so certain Careless scripts require `slurm` to run. 



