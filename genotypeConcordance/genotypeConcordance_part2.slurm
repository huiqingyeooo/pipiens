#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=24:00:00
#SBATCH --mem=100G
#SBATCH --output=slurm-%j.out

####### Set environment variables ###############
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/picard
PATH=/work/soghigian_lab/apps/bcftools-1.16/:$PATH

# define variables
projDir=/scratch/36768465
picardDir=${projDir}/6_picard_concordance/${1}
refGenome=${projDir}/refGenome/Cpip_nodebris_gapclosed_Apr4.fasta

#env PERL5LIB= PERL_LOCAL_LIB_ROOT= parallel sbatch genotypeConcordance_part2.slurm ::: angsd ::: b7 b8 b9 b10 :::: list.txt

echo "starting run at: `date`"

####### Script ##################################
cd ${picardDir}

echo Running GenotypeConcordance for snpcaller ${1} batch ${2} sample ${3}

picard GenotypeConcordance \
  CALL_VCF=${2}_nanopore_norm.vcf \
  CALL_SAMPLE=${3}\
  O=${1}_${2}_${3}.vcf \
  TRUTH_VCF=${2}_illumina_norm.vcf \
  TRUTH_SAMPLE=${3}


echo "Job finised with exit code $? at: `date`"
