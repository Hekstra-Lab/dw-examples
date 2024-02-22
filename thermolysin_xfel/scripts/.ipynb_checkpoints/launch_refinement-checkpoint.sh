#!/bin/bash
#SBATCH -J refine
#SBATCH -p shared,serial_requeue,seas_compute  # partition (queue)
#SBATCH -n 4         # 8 cores
#SBATCH --mem 32G    # memory pool for all cores
#SBATCH -t 0-00:15   # time (D-HH:MM)

# source your copy of phenix here!
source /n/holylfs05/LABS/hekstra_lab/Lab/garden/phenix/phenix-1.20.1-4487/phenix_env.sh

REF="../../../refinement"
# Setup run directory
mkdir run_refinement
cd run_refinement

# Copy refine.eff
cp ${REF}/refine.eff .

# Run refinement
phenix.refine refine.eff --overwrite
