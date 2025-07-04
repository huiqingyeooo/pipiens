#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=24:00:00
#SBATCH --mem=80G

echo "starting run at: `date`"

####### Set environment variables ###############
module load lib/zlib/1.2.11
module load gcc/10.2.0
module load cmake
PATH=/work/soghigian_lab/apps/bcftools-1.16:$PATH
PATH=/work/soghigian_lab/apps/bowtie2-2.4.5-linux-x86_64:$PATH
PATH=/work/soghigian_lab/apps/samtools-1.15/bin:$PATH
PATH=$PATH:/work/soghigian_lab/apps/bedtools2/bin

# define variables
refGenome=/work/soghigian_lab/huiqing.yeo/pipiens/refGenome/quinquefasciatus
fastpFiles=/work/soghigian_lab/huiqing.yeo/pipiens/lane1
bamFiles=/work/soghigian_lab/huiqing.yeo/pipiens/0_alignedReads_quinque

#Loop code 
#cd /work/soghigian_lab/huiqing.yeo/pipiens/lane1
#for sample in $(ls *_outfile1.fq.gz);
#do
#file=`echo $sample | awk -F"_" '{print $1}'`
#cd /work/soghigian_lab/huiqing.yeo/pipiens
#sed "s/TEMPLATE/${file}/g" bowtie_quinque_TEMPLATE.slurm > bowtie_quinque_${file}.slurm 
#sbatch bowtie_quinque_${file}.slurm
#sleep 1
#done

####### Script ##################################
cd /scratch/${SLURM_JOB_ID}
echo check /scratch/${SLURM_JOB_ID}
echo TEMPLATE-quinque

bowtie2 -p 12 --phred33 --local -x ${refGenome}/QUINQUE --rg-id lane1 --rg SM:TEMPLATE \
-1 ${fastpFiles}/TEMPLATE_outfile1.fq.gz -2 ${fastpFiles}/TEMPLATE_outfile2.fq.gz -U ${fastpFiles}/TEMPLATE_s.fq.gz -S ./TEMPLATE.sam

samtools view -bS TEMPLATE.sam > TEMPLATE.bam
samtools sort TEMPLATE.bam -o TEMPLATE_sorted.bam

cp ./TEMPLATE_sorted.bam ${bamFiles}

echo "Job finised with exit code $? at: `date`"