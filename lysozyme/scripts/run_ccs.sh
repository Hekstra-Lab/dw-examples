#!/bin/bash

#please activate your desired careless environment here!
eval "$(conda shell.bash hook)"
conda activate careless

dir_header=$1
for dir in ./careless_runs/${dir_header}
do
  echo $dir
  cd $dir
  echo "$(pwd)"
  careless.ccpred *_predictions_[0-1].mtz -o ccpred_res.csv --image ccpred_careless.png -b 10 -m spearman 
  careless.ccpred *_predictions_[0-1].mtz -o ccpred_overall_careless.csv -b 1 -m spearman
  # careless.ccanom *xval_combined.mtz -o ccanom_res.csv --image ccanom_res.png -b 10 -m spearman
  # careless.ccanom *xval_combined.mtz -o ccanom_overall.csv -b 1 -m spearman
  #careless.cchalf *xval_combined.mtz -o cchalf_res.csv --image cchalf_res.png -b 10 -m spearman
  #careless.cchalf *xval_combined.mtz -o cchalf_overall.csv -b 1 -m spearman
  cd ../../
done
