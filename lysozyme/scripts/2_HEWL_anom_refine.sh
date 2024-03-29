for R in 0.00000 0.50000 0.75000 0.87500 0.93750 0.96875 0.98438 0.99219 0.99609 0.99805 0.99902 0.99951 0.99976 0.99990 neg1; do
	REFINE=./careless_runs/phenix_poly_dw_mlp32_PEF_R${R}_0999_dmin1pt73
    rm -rf ${REFINE}/Refine_* myoutput_*
	mkdir ${REFINE}/Refine_1 ${REFINE}/Refine_2 ${REFINE}/Refine_3 ${REFINE}/Refine_4
	cp ./scripts/custom_refinement_param_1.eff ${REFINE}/Refine_1/
	cp ./scripts/custom_refinement_param_2.eff ${REFINE}/Refine_2/
    cp ./scripts/custom_refinement_param_1.eff ${REFINE}/Refine_3/
    cp ./scripts/custom_refinement_param_2.eff ${REFINE}/Refine_4/
	sbatch ./scripts/sbatch_phenix_Refine.sh ${REFINE} ${R}
done
