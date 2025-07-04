#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=48:00:00
#SBATCH --mem=100G

echo "starting run at: `date`"

####### Set environment variables ###############
export PERL5LIB=/work/soghigian_lab/apps/vcftools-0.1.16/src/perl
PATH=/work/soghigian_lab/apps/vcftools-0.1.16/src/perl:$PATH

# define variables
name=b2_plinkPruned_geno10

# converting vcf to fasta
cd /work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b2_nominmaf_minInd128/plink

zcat ${name}.vcf | vcf-to-tab > ${name}.snps.tab
perl /work/soghigian_lab/apps/vcf_tab_to_fasta_alignmentv1.pl -i ${name}.snps.tab > ${name}.snps

echo "Job finised with exit code $? at: `date`"
