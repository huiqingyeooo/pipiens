#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=8:00:00
#SBATCH --mem=80G

echo "starting run at: `date`"

####### Set environment variables ###############
PATH=/work/soghigian_lab/apps/fastp:$PATH
module load gcc/10.2.0
module load lib/zlib/1.2.11
module load perl/5.32.0

fastpInput=/work/soghigian_lab/data/illumina/chgi/mosquitoes/Plate1_lane2
fastpOutput=/work/soghigian_lab/huiqing.yeo/pipiens/0_trimmedReads/lane2
scripts=/work/soghigian_lab/huiqing.yeo/pipiens/scripts/pipiens

cd ${fastpOutput}

########## code for TEMPLATE jobs ###########
#for file in $(ls ${fastpInput}/*_R1.fastq.gz);
#do
#taxa=$(basename $file _R1.fastq.gz)
#taxname=`echo $file | awk -F"-" '{print $2}'`
#echo ${taxa}
#echo ${taxname}
#sed "s/TEMPLATE/${taxname}/g;s/SAMPLE/${taxa}/g" ${scripts}/fastp_lane2_TEMPLATE.slurm > ${fastpOutput}/fastp_${taxname}.slurm
#sbatch ${fastpOutput}/fastp_${taxname}.slurm --output ${fastpOutput}/slurm-%j.out
#sleep 1
#done

echo sample_TEMPLATE

fastp -i ${fastpInput}/SAMPLE_R1.fastq.gz -I ${fastpInput}/SAMPLE_R2.fastq.gz \
--out1 ${fastpOutput}/TEMPLATE_outfile1.fq.gz --out2 ${fastpOutput}/TEMPLATE_outfile2.fq.gz \
--unpaired1 ${fastpOutput}/TEMPLATE_unpa1.fq.gz --unpaired2 ${fastpOutput}/TEMPLATE_unpa2.fq.gz \
--detect_adapter_for_pe --cut_front -g -x -w 20 --trim_tail1 3 \
-h ${fastpOutput}/TEMPLATE.html -j ${fastpOutput}/TEMPLATE.json

cat ${fastpOutput}/TEMPLATE_unpa*.fq.gz > ${fastpOutput}/TEMPLATE_s.fq.gz

rm TEMPLATE_unpa1.fq.gz
rm TEMPLATE_unpa2.fq.gz
echo TEMPLATE_done

echo "Job finised with exit code $? at: `date`"
