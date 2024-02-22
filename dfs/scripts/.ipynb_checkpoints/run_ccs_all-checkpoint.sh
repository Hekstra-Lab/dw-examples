#!/bin/bash

#please indicate your desired careless environment here!
eval "$(conda shell.bash hook)"
conda activate careless
dir_header=$1
for dir in careless_runs/${dir_header}
do
  echo $dir
  cd $dir
  echo "$(pwd)"
  IFS='_' read -ra ADDR <<< "$dir"
  TMP_R=${ADDR[-1]}
  echo ${TMP_R:0:-1}
  careless.ccpred dfs_predictions_*.mtz -o ccpred_res.csv --image ccpred_careless.png -b 10 -m spearman 
  careless.ccpred dfs_predictions_*.mtz -o ccpred_overall_careless.csv -b 1 -m spearman
  cd ../..
done
