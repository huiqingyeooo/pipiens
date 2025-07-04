#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=48:00:00
#SBATCH --mem=80G

####### Set environment variables ###############
# activate conda for angsd
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/pcangsd

# define variables
pcangsdInput=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b3_nominmaf_minInd104/plink
pcangsdOutput=/work/soghigian_lab/huiqing.yeo/pipiens/4_pcangsd/b3
angsdBatchName=b3

echo "starting run at: `date`"
echo "b3_chr${1}_K${2}"

#env PERL5LIB= PERL_LOCAL_LIB_ROOT= parallel sbatch pcangsd_b3_chr.slurm ::: $(seq 3) ::: 2 3 4 5 6

####### Script ##################################
# Useful tutorial: https://www.popgen.dk/software/index.php/PCAngsdTutorial
# pcangsd uses a default minmaf value of 0.05

mkdir ${pcangsdOutput}
cd ${pcangsdInput}
pcangsd -b ${angsdBatchName}_plinkPruned_chr${1}.beagle.gz -o ${pcangsdOutput}/${angsdBatchName}_chr${1}_K${2} -t 12 --selection --inbreed_samples --admix --admix_K ${2} --sites_save --iter 1000

echo "Job finised with exit code $? at: `date`"
