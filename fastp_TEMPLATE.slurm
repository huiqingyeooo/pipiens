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

fastpInput=/work/soghigian_lab/huiqing.yeo/pipiens/0_trimmedReads_AGS/fastq_symlinks
fastpOutput=/work/soghigian_lab/huiqing.yeo/pipiens/0_trimmedReads_AGS
cd /work/soghigian_lab/huiqing.yeo/pipiens/0_trimmedReads_AGS

########## code for TEMPLATE jobs ###########
#cd /work/soghigian_lab/huiqing.yeo/pipiens/0_trimmedReads_AGS/fastq_symlinks
#for file in $(ls *_R1.fastq.gz);
#do
#taxa=$(basename $file _R1.fastq.gz)
#echo ${taxa}
#sed "s/TEMPLATE/${taxa}/g" fastp_TEMPLATE.slurm > fastp_${taxa}.slurm
#sbatch fastp_${taxa}.slurm
#sleep 1
#done

echo sample_TEMPLATE

fastp -i ${fastpInput}/TEMPLATE_R1.fastq.gz -I ${fastpInput}/TEMPLATE_R2.fastq.gz \
--out1 ${fastpOutput}/TEMPLATE_outfile1.fq.gz --out2 ${fastpOutput}/TEMPLATE_outfile2.fq.gz \
--unpaired1 ${fastpOutput}/TEMPLATE_unpa1.fq.gz --unpaired2 ${fastpOutput}/TEMPLATE_unpa2.fq.gz \
--detect_adapter_for_pe --cut_front -g -x -w 20 -h ${fastpOutput}/TEMPLATE.html --trim_tail1 3

cat ${fastpOutput}/TEMPLATE_unpa*.fq.gz > ${fastpOutput}/TEMPLATE_s.fq.gz

rm TEMPLATE_unpa1.fq.gz
rm TEMPLATE_unpa2.fq.gz
echo TEMPLATE_done

echo "Job finised with exit code $? at: `date`"
