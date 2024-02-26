#!/bin/bash
#SBATCH --job-name=mac1_diffmap
#SBATCH -p shared,seas_compute,serial_requeue # partition (queue)
#SBATCH --mem 8G # memory pool for all cores
#SBATCH -t 0-00:10 # time (D-HH:MM)
#SBATCH -c 2
#SBATCH -o logs/%j.out        # Standard output
#SBATCH -e logs/%j.err        # Standard error


# to run this script, rs-booster must be active. 

refnum=1 #this is the reference dataset: the apo, merged conditional on apo 
datasets=("P0115" "P0116" "P0123" "P0124" "P0131" "P0132" "P0137" "P0138" "P0139" "P0142" "P0148" "P0159" "P0161" "P0163" "P0178" "P0179")

len=${#datasets[@]}

for ds_num in $(seq 1 $len);do
    num=$(($ds_num+1))
    rs.scaleit -r dfs_${refnum}.mtz F SigF \
-i dfs_${num}.mtz F SigF \
-o dfs_${num}_scaled.mtz

    # rs.diffmap -on dfs_${num}_scaled.mtz FPH1 SIGFPH1 \
    # -off dfs_${refnum}.mtz F SigF \
    # -r ../../DFS_refine_mv.mtz PHIF-model -d 5 \
    # -a 0.05 -o wdm_${num}.mtz
    
    rs.diffmap -on dfs_${num}_scaled.mtz FPH1 SIGFPH1 \
    -off dfs_${refnum}.mtz F SigF \
    -r ../../scripts/DFS_refine_uv.mtz PHIF-model -d 5 \
    -a 0.05 -o wdm_${num}_uv.mtz

    dataset=${datasets[$(($ds_num-1))]}
    echo ${dataset}
    #rs.find_difference_peaks -f wDF -p Phi -z 5 wdm_${num}.mtz ../../20221007_unscaled_unmerged/UCSF-${dataset}/UCSF-${dataset}-pandda-model.pdb -o out_${dataset}.csv
    
    #rs.find_difference_peaks -f DF -p Phi -z 5 wdm_${num}.mtz ../../20221007_unscaled_unmerged/UCSF-${dataset}/UCSF-${dataset}-pandda-model.pdb -o out_${dataset}_noweights.csv
    
    rs.find_difference_peaks -f DF -p Phi -z 5 wdm_${num}_uv.mtz ../../20221007_unscaled_unmerged/UCSF-${dataset}/UCSF-${dataset}-pandda-model.pdb -o out_${dataset}_noweights_uv.csv
done