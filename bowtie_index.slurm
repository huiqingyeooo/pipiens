#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --time=12:00:00
#SBATCH --mem=80G

####### Set environment variables ###############
module load lib/zlib/1.2.11
module load gcc/10.2.0
module load cmake
PATH=/work/soghigian_lab/apps/bcftools-1.16:$PATH
PATH=/work/soghigian_lab/apps/bowtie2-2.4.5-linux-x86_64:$PATH
PATH=/work/soghigian_lab/apps/samtools-1.15/bin:$PATH
PATH=$PATH:/work/soghigian_lab/apps/bedtools2/bin

echo "starting run at: `date`"

####### Script ##################################
#cd /work/soghigian_lab/huiqing.yeo/pipiens/refGenome/
cd /work/soghigian_lab/huiqing.yeo/pipiens/wolbachia/refGenome

# Build index for the reference genome
#bowtie2-build -f ./pipiens/Cpip29_nodebris_gapfill.fasta PIPIENS
#bowtie2-build -f ./quinquefasciatus/GCF_015732765.1_VPISU_Cqui_1.0_pri_paternal_genomic.fna QUINQUE
bowtie2-build -f GCF_000008025.1_ASM802v1_genomic.fna.gz WPIP

echo "Job finised with exit code $? at: `date`"
