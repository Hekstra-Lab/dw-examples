eval "$(conda shell.bash hook)"
conda activate laue

##to run rs.scaleit, source ccp4 in this line!
source /n/hekstra_lab_tier0/Lab/garden/ccp4/ccp4-7.1/bin/ccp4.setup-sh

dir_header=$1
for dir in careless_runs/${dir_header}
do
    echo $dir
    cd $dir
    echo "$(pwd)"
    IFS='_' read -ra ADDR <<< "$dir"
    TMP_R=${ADDR[-1]}
    echo ${TMP_R:0:-1}
    cp ../../scripts/make_diffmap_indiv.sh . 
    sbatch make_diffmap_indiv.sh
    cd ../../
    
done