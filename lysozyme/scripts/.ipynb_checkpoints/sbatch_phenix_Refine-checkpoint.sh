#!/bin/bash
#SBATCH --job-name=Refine1
#SBATCH -p shared,seas_compute # partition (queue)
#SBATCH -n 4 # 4 cores
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-00:10 # time (D-HH:MM)
#SBATCH -o myoutput_%j.out
#SBATCH -e myoutput_%j.err

## Commandline variables
# 1: upper refinement directory
# 2: number of frames

# your phenix source goes here!
source /n/hekstra_lab_tier0/Lab/garden/phenix/phenix-1.20.1-4487/phenix_env.sh
#source ../../../../../../phenix-1.20.1-4487/phenix_env.sh

# run refinement
cd $1/Refine_1
phenix.refine "custom_refinement_param_1.eff" \
	refinement.input.xray_data.file_name=../HEWL_dw_mlp32_PEF_R$2_0999_dmin1.73_combined.mtz \
	refinement.input.pdb.file_name=../../../scripts/HEWL_starting_model-ions_occ0.pdb \
	refinement.output.prefix=mlp32_PEF_R$2_0999_dmin1pt73_new_refine

cd ../Refine_2
phenix.refine "custom_refinement_param_2.eff" \
	refinement.input.xray_data.file_name=../Refine_1/mlp32_PEF_R$2_0999_dmin1pt73_new_refine_data.mtz \
	refinement.input.pdb.file_name=../Refine_1/mlp32_PEF_R$2_0999_dmin1pt73_new_refine_1.pdb \
    refinement.input.xray_data.r_free_flags.file_name=../Refine_1/mlp32_PEF_R$2_0999_dmin1pt73_new_refine_data.mtz \
	refinement.output.prefix=mlp32_PEF_R$2_0999_dmin1pt73_new_refine
    
cd ../Refine_3
phenix.refine "custom_refinement_param_1.eff" \
	refinement.input.xray_data.file_name=../HEWL_dw_mlp32_PEF_R$2_0999_dmin1.73_combined.mtz \
	refinement.input.pdb.file_name=../../../scripts/HEWL_starting_model.pdb \
	refinement.output.prefix=mlp32_PEF_R$2_0999_dmin1pt73_new_refine

cd ../Refine_4
phenix.refine "custom_refinement_param_2.eff" \
	refinement.input.xray_data.file_name=../Refine_3/mlp32_PEF_R$2_0999_dmin1pt73_new_refine_data.mtz \
	refinement.input.pdb.file_name=../Refine_3/mlp32_PEF_R$2_0999_dmin1pt73_new_refine_1.pdb \
    refinement.input.xray_data.r_free_flags.file_name=../Refine_3/mlp32_PEF_R$2_0999_dmin1pt73_new_refine_data.mtz \
	refinement.output.prefix=mlp32_PEF_R$2_0999_dmin1pt73_new_refine

# clean up
cd ../../../
mv myoutput*${SLURM_JOB_ID}*.* $1/
