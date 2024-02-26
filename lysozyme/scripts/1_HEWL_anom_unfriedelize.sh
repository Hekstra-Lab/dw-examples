#!/bin/bash

#source your conda environments here!
eval "$(conda shell.bash hook)"
conda activate careless

for R in 0.00000 0.50000 0.75000 0.87500 0.93750 0.96875 0.98438 0.99219 0.99609 0.99805 0.99902 0.99951 0.99976 0.99990 neg1; do

    if [ $R == 'neg1' ];
    then
        R_=-1.00000
    else
        R_=$R
    fi
    
	MERGE=careless_runs/merge_HEWL_dw_mlp32_PEF_R${R}_0999_dmin1.73_*_poly
	cd ${MERGE}
	python ../../scripts/unfriedelize.py HEWL_dw_mlp32_PEF_R${R_}_0999_dmin1.73_0.mtz HEWL_dw_mlp32_PEF_R${R_}_0999_dmin1.73_1.mtz HEWL_dw_mlp32_PEF_R${R_}_0999_dmin1.73_combined.mtz
	python ../../scripts/unfriedelize_xval.py HEWL_dw_mlp32_PEF_R${R_}_0999_dmin1.73_xval_0.mtz HEWL_dw_mlp32_PEF_R${R_}_0999_dmin1.73_xval_1.mtz HEWL_dw_mlp32_PEF_R${R_}_0999_dmin1.73_xval_combined.mtz
	REFINE=../phenix_poly_dw_mlp32_PEF_R${R}_0999_dmin1pt73
	mkdir ${REFINE}
	cp *_combined.mtz ${REFINE}
	cd ../../
done
