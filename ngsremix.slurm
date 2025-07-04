#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --time=72:00:00
#SBATCH --mem=150G

echo "starting run at: `date`"

####### Set environment variables ###############
PATH=/work/soghigian_lab/apps/NGSremix/src:$PATH

# define variables
input=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b3_nominmaf_minInd104/plink
file=b3_plinkPruned
ngsadmix=/work/soghigian_lab/huiqing.yeo/pipiens/5_ngsadmix/b3

####### Script ##################################
cd /work/soghigian_lab/huiqing.yeo/pipiens/7_ngsremix

NGSremix -beagle ${input}/${file}.beagle.gz -qname ${ngsadmix}/b3.minmaf0.K2.rep1.out.qopt -fname ${ngsadmix}/b3.minmaf0.K2.rep1.out.fopt.gz -seed 1 -o ${file}_v2 -P 12

echo "Job finised with exit code $? at: `date`"
