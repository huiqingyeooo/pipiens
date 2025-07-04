#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=24:00:00
#SBATCH --mem=100G
#SBATCH --output=slurm-b2_%j.out

####### Set environment variables ###############
PATH=/work/soghigian_lab/apps/ngsRelate:$PATH
PATH=/work/soghigian_lab/apps/angsd:$PATH

batchName=b2
input=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b2_nominmaf_minInd128/plink
output=/work/soghigian_lab/huiqing.yeo/pipiens/9_ngsrelate

echo "starting run at: `date`"

####### Script ##################################
ngsRelate  -h ${input}/b2_plinkPruned.vcf.gz -O ${output}/b2_plinkPruned.res


echo "Job finised with exit code $? at: `date`"
