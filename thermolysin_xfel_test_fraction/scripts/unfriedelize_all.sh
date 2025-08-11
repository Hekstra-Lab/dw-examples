#!/bin/bash

#source your conda environments here!
eval "$(conda shell.bash hook)"
conda activate careless_021

BASE="thl_1p8A_grid"

#change this directory as needed

out_dirs=$1
for dir in ./careless_runs/$out_dirs
do
  echo $dir
  cd $dir
  python ../../scripts/unfriedelize.py ${BASE}_0.mtz ${BASE}_1.mtz ${BASE}_both.mtz 
  python ../../scripts/unfriedelize.py ${BASE}_xval_0.mtz ${BASE}_xval_1.mtz ${BASE}_xval_both.mtz -x
  cp ../../scripts/launch_refinement_omit.sh .
  cp ../../scripts/launch_refinement.sh .
  sbatch launch_refinement_omit.sh
  sbatch launch_refinement.sh
  cd ../../
done

