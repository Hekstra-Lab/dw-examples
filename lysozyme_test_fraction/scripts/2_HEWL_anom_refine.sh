for R in neg1; do #0.00000 0.50000 0.75000 0.87500 0.93750 0.96875 0.98438 0.99219 0.99609 0.99805 0.99902 0.99951 0.99976 0.99990 neg1 precog; do
    
    if [ $R == 'neg1' ];
    then
        R_=-1.0000
    else
        R_=$R
    fi
    
	REFINE_LIST=./careless_runs/phenix_poly_dw_mlp32_PEF_R${R}_0720_dmin1pt8_*

    counter=0
    for REFINE in $REFINE_LIST; do
        #rm -rf ${REFINE}/Refine_* ${REFINE}/myoutput_*
        #mkdir ${REFINE}/Refine_1 ${REFINE}/Refine_2 ${REFINE}/Refine_3 ${REFINE}/Refine_4
        cp ./scripts/custom_refinement_param_1.eff ${REFINE}/Refine_1/
        cp ./scripts/custom_refinement_param_2.eff ${REFINE}/Refine_2/
        cp ./scripts/custom_refinement_param_1.eff ${REFINE}/Refine_3/
        cp ./scripts/custom_refinement_param_2.eff ${REFINE}/Refine_4/
    	sbatch ./scripts/sbatch_phenix_Refine.sh ${REFINE} ${R_}
    done
done
