#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=100G

####### Set environment variables ###############
#PATH=/work/soghigian_lab/apps/bcftools-1.16:$PATH
#PATH=/work/soghigian_lab/apps/vcftools-0.1.16/bin:$PATH
PATH=/work/soghigian_lab/apps/plink:$PATH

angsdOutput=/work/soghigian_lab/huiqing.yeo/pipiens/2_angsd/b3_nominmaf_minInd66/admixture_files
admixtureOutput=/work/soghigian_lab/huiqing.yeo/pipiens/5_admixture_pca
batchName=b3

echo "starting run at: `date`"

####### Script ##################################
cd ${admixtureOutput}

# perform linkage pruning with plink (refer to codes in admixture.slurm)
# copy files to pca folder
#cp ${angsdOutput}/${batchName}.LDpruned.bed .
#cp ${angsdOutput}/${batchName}.LDpruned.bim .
#cp ${angsdOutput}/${batchName}.LDpruned.fam .

# If using .bim files generated for admixture program, remember to add 'scaffold' back 
to the chromosome names
# otherwise plink will not work
# e.g. scaffold1 instead of 1
#sed -i 's/^\([0-9]\+\)/scaffold\1/' b3.LDpruned.bim

# pca
plink --bfile b3.LDpruned --allow-no-sex --allow-extra-chr --pca --out b3.pca

echo "Job finised with exit code $? at: `date`"
