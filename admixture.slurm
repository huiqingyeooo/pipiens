#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=100G

####### Set environment variables ###############
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/admixture

PATH=/work/soghigian_lab/apps/bcftools-1.16:$PATH
PATH=/work/soghigian_lab/apps/vcftools-0.1.16/bin:$PATH
PATH=/work/soghigian_lab/apps/plink:$PATH

angsdOutput=/work/soghigian_lab/huiqing.yeo/pipiens/2_angsd/b3_nominmaf_minInd66
admixtureOutput=/work/soghigian_lab/huiqing.yeo/pipiens/5_admixture
batchName=b3

echo "starting run at: `date`"

####### Script ##################################
cd ${angsdOutput}
mkdir admixture_files

#bcftools view ${batchName}.bcf > ${batchName}.vcf.gz

cd admixture_files
# If need to remove sites with missing data
# note: Treemix does not like missing data
#vcftools --gzvcf ${batchName}.vcf.gz --max-missing 1 --recode --stdout | gzip > ${batchName}.noN.vcf.gz

# Perform linkage pruning with ldPruning.sh or manually (codes below)

# Removes SNPs with r2>0.1 in a window of 50kb sliding by 10kb (ldPruning.sh)
# https://raw.githubusercontent.com/joanam/scripts/master/ldPruning.sh
#chmod +x ldPruning.sh
#./ldPruning.sh ${batchName}.vcf.gz 0.5

# generates plink files (bed, bim, fam) from vcf file
#plink --vcf ${angsdOutput}/${batchName}.vcf.gz --make-bed --allow-no-sex --allow-extra-chr --out ${batchName}

# generates files for subsequent pruning (plink.prune.in, plink.prune.out)
#plink --bfile ${batchName} --allow-no-sex --allow-extra-chr --indep 50 5 2 #using vif
#plink --bfile ${batchName} --allow-no-sex --allow-extra-chr --indep-pairwise 50 5 0.5 #using R^2

# perform pruning
#plink --bfile ${batchName} --extract plink.prune.in --allow-no-sex --allow-extra-chr --make-bed --out ${batchName}.LDpruned

# admixture only works when chromosome names are numerical
# search and remove 'scaffold_' from bim file
#cp ${batchName}.LDpruned.bim b2.LDpruned.original.bim
#sed -i 's/scaffold_//g' ${batchName}.LDpruned.bim

#mkdir ${admixtureOutput}
#cd ${admixtureOutput}
#mkdir ${batchName}
#cd ${batchName}

cp ${angsdOutput}/${batchName}.LDpruned.bed .
cp ${angsdOutput}/${batchName}.LDpruned.bim .
cp ${angsdOutput}/${batchName}.LDpruned.fam .

# run admixture
for K in 1 2 3 4 5; \
do admixture --cv ${batchName}.LDpruned.bed $K | tee log${K}.out; done

echo "Job finised with exit code $? at: `date`"
