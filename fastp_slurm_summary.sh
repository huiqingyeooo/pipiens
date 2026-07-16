fastpOutput=/work/soghigian_lab/huiqing.yeo/pipiens/0_trimmedReads/ags

# check slurm log files
for i in $(ls ${fastpOutput}/slurm-*.out);
do 
col1=`echo ${i}`
col2=`tail -n 1 ${i}`
echo $col1 $col2 >> ${fastpOutput}/slurm_summary.txt
done