#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=48:00:00
#SBATCH --mem=100G
#SBATCH --output=slurm-b6-%j.out

####### Set environment variables ###############
# activate conda for angsd
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/pcangsd

# define variables
pcangsdInput=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b6_nominmaf_minInd60/plink
pcangsdOutput=/work/soghigian_lab/huiqing.yeo/pipiens/4_pcangsd/b6
angsdBatchName=b6

#env PERL5LIB= PERL_LOCAL_LIB_ROOT= parallel sbatch pcangsd_b6.slurm ::: $(seq 6)

echo "starting run at: `date`"
echo pcangsd for K${1}

####### Script ##################################
# Useful tutorial: https://www.popgen.dk/software/index.php/PCAngsdTutorial
# pcangsd uses a default minmaf value of 0.05

mkdir ${pcangsdOutput}
cd ${pcangsdInput}
pcangsd -b ${angsdBatchName}_plinkPruned.beagle.gz -o ${pcangsdOutput}/${angsdBatchName}_K${1} -t 12 --selection \
--inbreed_samples --admix --admix_K ${1} --sites_save --iter 5000

# load R
#module load R/4.3.1
#Rscript ${pcangsdOutput}/${angsdBatchName}/pcangsd_plot.R

### Codes below are notes for myself
# To see first 10 lines and 10 columns of the beagle file
#gunzip -c Demo1input.gz | head -n 10 | cut -f 1-10 | column -t

# To count number of lines of the beagle file
#gunzip -c Demo1input.gz | wc -l

#To view a summary of a population information file, cut the first column, sort and count:
#cut -f 1 -d " " Demo1pop.info | sort | uniq -c

#population information file format for pcangsd
#pop1	sample1
#pop1	sample2
#pop2	sample3
#pop3	sample4
 
#cut -f1 -d" " Demo1pop.info > poplabel

echo "Job finised with exit code $? at: `date`"
