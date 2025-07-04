#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=10:00:00
#SBATCH --mem=60G
#SBATCH --output=slurm-b6-%j.out

####### Set environment variables ###############
PATH=/work/soghigian_lab/apps/ngsadmix:$PATH

# define variables
angsdOutput=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b6_nominmaf_minInd60/plink
ngsadmixOutput=/work/soghigian_lab/huiqing.yeo/pipiens/5_ngsadmix/b6
batchName=b6

#env PERL5LIB= PERL_LOCAL_LIB_ROOT= parallel sbatch ngsadmix_b6.slurm ::: $(seq 6) ::: $(seq 10)

echo "starting run at: `date`"
echo "running NGSadmix for b6.K${1}.rep${2}"

####### Script ##################################
mkdir ${ngsadmixOutput}
cd ${angsdOutput}

NGSadmix -likes ${batchName}_plinkPruned.beagle.gz -K ${1} -P 8 -o ${ngsadmixOutput}/${batchName}.K${1}.rep${2}.out

echo "Job finised with exit code $? at: `date`"
