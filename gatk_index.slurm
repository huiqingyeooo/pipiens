#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=20:00:00
#SBATCH --mem=100G

####### Set environment variables ###############
module load lib/zlib/1.2.11
module load gcc/10.2.0
PATH=/work/soghigian_lab/apps/samtools-1.15/bin:$PATH
PATH=/work/soghigian_lab/apps/qualimap_v2.2.1/:$PATH

# activate conda for picard and gatk3
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/picard

echo "starting run at: `date`"

####### Script - Part 1 ##################################
# Only needs to be done once

cd /work/soghigian_lab/huiqing.yeo/pipiens/refGenome/pipiens

# Index reference and create sequence dictionary for downstream processsing using picard and samtools (different from bowtie2)
# Note: indexed files have to be in the same directory as the ref genome fasta

picard CreateSequenceDictionary R=Cpip29_nodebris_gapfill.fasta O=Cpip29_nodebris_gapfill.dict
samtools faidx Cpip29_nodebris_gapfill.fasta

# might need to use samtools dict
# samtools dict Cpip29_nodebris_gapfill.fasta > Cpip_nodebris_gapfill.dict
