#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=48:00:00
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
refGenome=/work/soghigian_lab/huiqing.yeo/pipiens/refGenome/pipiens
fastpFiles=/work/soghigian_lab/huiqing.yeo/pipiens/0_trimmedReads_AGS
bamFiles=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads_pipiens_AGS

#Loop code 
#cd ${fastpFiles}
#for sample in $(ls *_outfile1.fq.gz);
#do
#file=`echo $sample | awk -F"_" '{print $1"_"$2"_"$3}'`
#echo ${file}
#cd ${bamFiles}
#sed "s/TEMPLATE/${file}/g" bowtie_pipiens_TEMPLATE.slurm > bowtie_pipiens_${file}.slurm 
#sbatch bowtie_pipiens_${file}.slurm
#sleep 1
#done

####### Script ##################################
cd /scratch/${SLURM_JOB_ID}
echo check /scratch/${SLURM_JOB_ID}
echo TEMPLATE-pipiens

bowtie2 -p 12 --phred33 --local -x ${refGenome}/PIPIENS -1 ${fastpFiles}/TEMPLATE_outfile1.fq.gz -2 ${fastpFiles}/TEMPLATE_outfile2.fq.gz -U ${fastpFiles}/TEMPLATE_s.fq.gz -S ./TEMPLATE.sam

#--rg-id lane2 --rg SM:TEMPLATE \

samtools view -bS TEMPLATE.sam > TEMPLATE.bam
rm TEMPLATE.sam
samtools sort TEMPLATE.bam -o TEMPLATE_sorted.bam
rm TEMPLATE.bam

cp ./TEMPLATE_sorted.bam ${bamFiles}


echo "Job finised with exit code $? at: `date`"
