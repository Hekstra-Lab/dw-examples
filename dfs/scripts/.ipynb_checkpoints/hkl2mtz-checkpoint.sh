eval "$(conda shell.bash hook)"
conda activate careless #please source your careless-containing environment here!

#this script uses careless.xds2mtz for writing mtz files from XDS files. 

cd ../20221007_unscaled_unmerged/reference/
careless.xds2mtz als_20200708_FRS_017_P4_INTEGRATE.HKL out.mtz

for i in ../20221007_unscaled_unmerged/UCSF-P*/ 
do
    cd $i
    careless.xds2mtz *.HKL out.mtz
    cd ../
done