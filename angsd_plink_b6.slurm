#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --time=24:00:00
#SBATCH --mem=100G
#SBATCH --output=slurm-angsd-b6-%j.out

####### Set environment variables ###############
# activate conda for angsd
#source ~/software/init-conda-sl
#conda activate /work/soghigian_lab/apps/conda/envs/angsd
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/plink2
PATH=/work/soghigian_lab/apps/angsd:$PATH
PATH=/work/soghigian_lab/apps/plink:$PATH

# define variables
bamFolder=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/symlinks
angsdFolder=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd
bamList=bam74.filelist
batchName=b6
minInd=60

angsdParameters=nominmaf_minInd60
SNPlist=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b6_nominmaf_minInd60/plink/${batchName}_plinkPruned.SNPlist.txt

mkdir ${angsdFolder}/${batchName}_${angsdParameters}

echo "starting run at: `date`"

####### Script ##################################
# Note: use multiple flags to generate different file formats needed for various downstream programs at once from a single angsd run
#cd ${bamFolder}

# angsd
#angsd -b ${bamFolder}/${bamList} -out ${angsdFolder}/${batchName}_${angsdParameters}/${batchName} -nThreads 24 \
#-doGeno 4 -doglf 2 -doPost 1 -doCounts 1 -doplink 2 -doQsDist 1 -doDepth 1 -doMaf 2 -GL 1 -doMajorMinor 1 -dobcf 1 -doHWE 1 -dosnpstat 1 \
#-SNP_pval 1e-6 -minMapQ 20 -minQ 30 -minInd ${minInd} -setMinDepthInd 3 -geno_mindepth 3 -only_proper_pairs 1 -remove_bads 1 -uniqueOnly 1 -skipTriallelic 1

# Add detailes of sites to .arg file
tail -n 5 slurm-*-$SLURM_JOBID.out| head -n 1 >> ${angsdFolder}/${batchName}.arg
tail -n 4 slurm-*-$SLURM_JOBID.out| head -n 1 >> ${angsdFolder}/${batchName}.arg

# convert bcf to bed format (generates .bed, .bim, .fam, .ped, .map files)
# using plink to convert, plink2 does not have -bcf option yet
# could also probably convert bcf to vcf with bcftools, then run plink2 directly
#cd ${angsdFolder}/${batchName}_${angsdParameters}
#mkdir plink
#plink --bcf ${batchName}.bcf --recode --make-bed --allow-no-sex --allow-extra-chr --out ./plink/${batchName}

#  generate bed files with variant ids neded for pruning
#cd plink
#plink2 --bfile ${batchName} --set-missing-var-ids @_#_\$r_\$a --out ${batchName}.rename --make-bed --allow-extra-chr

# generate a list of SNP IDs which are pruned
# window size in SNPs (50), number of SNPs to shift (5), vif threshold (2), or r^2 threshold (0.5)
# --indep 50 5 2 and --allow-no-sex does not work in plink2?
#plink2 --bfile ${batchName}.rename --allow-extra-chr --indep-pairwise 50 5 0.5 --set-missing-var-ids @_#_\$r_\$a

# extract SNP data
#plink2 --bfile ${batchName}.rename --extract plink2.prune.in --make-bed --allow-extra-chr --out ${batchName}_plinkPruned

#format output in vcf format
#plink2 --bfile ${batchName}_plinkPruned --allow-extra-chr --recode vcf --out ${batchName}_plinkPruned --missing

#rm ${batchName}.bed ${batchName}.bim ${batchName}.fam ${batchName}.log ${batchName}.nosex ${batchName}.ped ${batchName}.map
#rm ${batchName}.rename.bed ${batchName}.rename.bim ${batchName}.rename.fam ${batchName}.rename.log

# generate pruned SNP list for downstream angsd processes
#cut -f1,4 ${batchName}_plinkPruned.bim > ${batchName}_plinkPruned.SNPlist.txt

# Specify SNP list and index
#angsd sites index ${batchName}_plinkPruned.SNPlist.txt

### Below are codes that may be needed in plink
# exclude loci with missing SNPs (for ResDisMapper)
# plink2 --bfile ${batchName}_plinkPruned --allow-extra-chr --recode vcf --geno 0 --out ${batchName}_plinkPruned_noMissing
# plink2 --bfile ${batchName}_plinkPruned --allow-extra-chr --recode vcf --geno 0.1 --out ${batchName}_plinkPruned_geno10

# to remove individuals, use --remove followed by a text file
# text file needs to have two columns of the same samples similar to .fam file
#plink2 --bfile ${batchName}_plinkPruned --remove remove_list.txt --allow-extra-chr --recode vcf 
--geno 0 --out ${batchName}_plinkPruned_noMissing

#format output in structure format
#plink2 --bfile ${batchName}_plinkPruned --allow-extra-chr --recode structure --out ${batchName}_plinkPruned

# angsd (with pruned snp list)
cd ${bamFolder}
angsd -b ${bamFolder}/${bamList} -out ${angsdFolder}/${batchName}_${angsdParameters}/${batchName}_plinkPruned -nThreads 24 \
-doGeno 4 -doglf 2 -doPost 1 -doCounts 1 -doplink 2 -doQsDist 1 -doDepth 1 -doMaf 2 -GL 1 -doMajorMinor 1 -dobcf 1 -doHWE 1 \
-SNP_pval 1e-6 -minMapQ 20 -minQ 30 -minInd ${minInd} -setMinDepthInd 3 -geno_mindepth 3 -only_proper_pairs 1 -remove_bads \
-doCov 1 -doIBS 1 -makeMatrix 1 \
-sites ${SNPlist}

#plotQC.R
#- computes percentiles of the quality scores and depth distributions
#- use this output to make informative decision on threshold values used for filtering 
#(examine plots in pdf)
#- flags -doQsDist 1 -doDepth 1 -doCounts 1 need to be specified to generate files for plotQC.R

echo "Job finised with exit code $? at: `date`"
