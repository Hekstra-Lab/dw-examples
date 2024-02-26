#!/bin/bash
#SBATCH --job-name=careless
#SBATCH -p gpu_requeue,seas_gpu # partition (queue)
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-8:00 # time (D-HH:MM)
#SBATCH --gres=gpu:1
#SBATCH --constraint=v100
#SBATCH -o myoutput_%j.out
#SBATCH -e myoutput_%j.err

MODE="poly"
MC_SAMPLES=10
IL=0
MLPL=10
ITER=30000
STDOF=64
PEF=4
RU=0        # 1 turns on --refine-uncertainties
SEED=$RANDOM
TEST_FRACTION=0.1
HALF_REPEATS=3

MLPW=32
FRAMES=0999
R=-1.00000 	#R<0 defaults to univariate prior
DMIN=1.73

INPUT_MTZS=(
    ../unmerged_mtzs/integrated_NaI_3_04_frame_0001_${FRAMES}_plus.mtz
    ../unmerged_mtzs/integrated_NaI_3_04_frame_0001_${FRAMES}_minus.mtz
)

DW_LIST=None,0
USE_DW="DW"
DWR_LIST=0.,${R}

#Source your installation of careless here. To install careless, see: https://github.com/rs-station/careless
# eval "$(conda shell.bash hook)"
# conda activate careless

source /n/home12/mklureza/opt/anaconda/etc/profile.d/conda.sh
conda activate careless_gpu_new

BASENAME=HEWL_dw_mlp${MLPW}_PEF_R${R}_${FRAMES}_dmin${DMIN}
OUT=merge_${BASENAME}_${SLURM_JOB_ID}_${MODE}

mkdir -p $OUT
cp $0 $OUT
cat $0 > $OUT/slurm_script


SECONDS=0
CARELESS_ARGS=(
    --separate-files
    --mc-samples=$MC_SAMPLES
    --merge-half-datasets
    --half-dataset-repeats=$HALF_REPEATS
    --mlp-layers=$MLPL
    --mlp-width=$MLPW
    --image-layers=$IL
    --positional-encoding-frequencies=$PEF
    --positional-encoding-keys="xcal,ycal,BATCH"
    --dmin=$DMIN
    --iterations=$ITER
    --test-fraction=$TEST_FRACTION
    --seed=$SEED
    --wavelength-key='wavelength'
)
# WARNING: bash [] comparisons only work for integers
c=$(echo "$R > -0.01" | bc)
if [ $c = '1' ]
then
  CARELESS_ARGS+=(--double-wilson-parents=${DW_LIST}) 
  CARELESS_ARGS+=(--double-wilson-r=${DWR_LIST})
fi
if [ $IL -lt 0 ]
then
  CARELESS_ARGS+=( --disable-image-scales)
fi
if [ $RU -gt 0 ]
then
  CARELESS_ARGS+=( --refine-uncertainties)
fi
if [ $STDOF -gt 0 ]
then
  CARELESS_ARGS+=( --studentt-likelihood-dof=$STDOF)
fi
CARELESS_ARGS+=("BATCH,xcal,ycal,dHKL,Hobs,Kobs,Lobs,wavelength")

echo $CARELESS_ARGS
echo "Input MTZs: ${INPUT_MTZS[@]}" > ./$OUT/inputs_params.log
echo "Args: $MODE ${CARELESS_ARGS[@]}" >> ./$OUT/inputs_params.log
echo "Careless version: ${CARELESS_VERSION}" >> ./$OUT/inputs_params.log
conda list > ./$OUT/conda_env_record.log
nvidia-smi > ./$OUT/nvidia-smi.log

careless $MODE ${CARELESS_ARGS[@]} ${INPUT_MTZS[@]} $OUT/$BASENAME


# --- Cleanup --- #
echo "careless run complete."
mv myoutput*${SLURM_JOB_ID}* $OUT

DURATION=$SECONDS
TITLE="Slurm: careless"
MESSAGE="Job $SLURM_JOB_ID:careless finished on $HOSTNAME in $(($DURATION / 60)) minutes."
echo $MESSAGE

