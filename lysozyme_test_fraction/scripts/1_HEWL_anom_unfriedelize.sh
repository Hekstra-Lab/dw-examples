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
    counter=0
	MERGE=careless_runs/merge_HEWL_dw_mlp32_PEF_R${R_}_0720_dmin1.8_*_poly
     for ds in $MERGE; do
        
    	cd ${ds}
    	# python ../../scripts/unfriedelize.py HEWL_dw_mlp32_PEF_R${R_}_0720_dmin1.8_0.mtz HEWL_dw_mlp32_PEF_R${R_}_0720_dmin1.8_1.mtz HEWL_dw_mlp32_PEF_R${R_}_0720_dmin1pt8_combined.mtz
     #    python ../../scripts/unfriedelize_xval.py HEWL_dw_mlp32_PEF_R${R_}_0720_dmin1.8_xval_0.mtz HEWL_dw_mlp32_PEF_R${R_}_0720_dmin1.8_xval_1.mtz HEWL_dw_mlp32_PEF_R${R_}_0720_dmin1pt8_xval_combined.mtz
    	REFINE=../phenix_poly_dw_mlp32_PEF_R${R}_0720_dmin1pt8_${counter}
        counter=$(($counter+1))
    	# mkdir ${REFINE}
        cp inputs_params.log ${REFINE}
    	cp *_combined.mtz ${REFINE}
    	cd ../../
     done
done


	#