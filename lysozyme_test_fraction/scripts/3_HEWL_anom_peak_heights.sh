#!/bin/bash

#source your conda environments here!
eval "$(conda shell.bash hook)"
conda activate careless


for R in 0.00000 0.50000 0.75000 0.87500 0.93750 0.96875 0.98438 0.99219 0.99609 0.99805 0.99902 0.99951 0.99976 0.99990 neg1; do

    if [ $R == 'neg1' ];
    then
        R_=-1.0000
    else
        R_=$R
    fi

for ds in 0 1 2; do 
    mtz_filename=./careless_runs/phenix_poly_dw_mlp32_PEF_R${R}_0720_dmin1pt8_${ds}/Refine_2/mlp32_PEF_R${R_}_0720_dmin1pt8_new_refine_2.mtz
    pdb_filename=./careless_runs/phenix_poly_dw_mlp32_PEF_R${R}_0720_dmin1pt8_${ds}/Refine_4/mlp32_PEF_R${R_}_0720_dmin1pt8_new_refine_2.pdb
    output_csv=./careless_runs/phenix_poly_dw_mlp32_PEF_R${R}_0720_dmin1pt8_${ds}/peak_heights.csv
	python ./scripts/anomalous_peak_heights.py ${mtz_filename} ${pdb_filename} [I,S] ${output_csv}
    csv_list+=(${output_csv})
done
done
python ./scripts/concatenate_anomalous_peak_csv.py ./HEWL_anom_peak_heights.csv "0.00000 0.50000 0.75000 0.87500 0.93750 0.96875 0.98438 0.99219 0.99609 0.99805 0.99902 0.99951 0.99976 0.99990 -1.00000 -3.00000" "${csv_list[@]}"