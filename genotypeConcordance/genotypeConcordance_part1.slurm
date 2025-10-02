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

snpcaller=${1}

if [ ${snpcaller} == "angsd" ]; then
  nanopore=${projDir}/3_angsd
  illumina=${projDir}/3_angsd_illumina
  echo snpcaller is angsd
elif [ ${snpcaller} == "bcftools" ]; then
  nanopore=${projDir}/5_bcftools_mpileup
  illumina=${projDir}/5_bcftools_mpileup_illumina
  echo snpcaller is bcftools
elif [ ${snpcaller} == "clair3" ]; then
  nanopore=${projDir}/7_clair
  illumina=${projDir}/7_clair_illumina
  echo snpcaller is clair3
else
  echo snpcaller was not specified properly
fi

echo ${nanoporeDir}
echo ${illuminaDir}

#env PERL5LIB= PERL_LOCAL_LIB_ROOT= parallel sbatch genotypeConcordance_part1.slurm ::: angsd ::: b7 b8 b9 b10

echo "starting run at: `date`"

####### Script ##################################
mkdir ${picardDir}
cd ${picardDir}

cp ${nanopore}/${2}*/${2}.vcf.gz ${2}_nanopore.vcf.gz
cp ${illumina}/${2}*/${2}.vcf.gz ${2}_illumina.vcf.gz

# Fix REF alleles is congruent so that it is congruent with reference genome
# The use of PLINK can produce vcfs with different REF alleles from ref genome
# Especially if it is built from genotype data rather than actual alignments
bcftools norm -f ${refGenome} -c ws -Ou -o ${2}_nanopore_norm.vcf ${2}_nanopore.vcf.gz
bcftools norm -f ${refGenome} -c ws -Ou -o ${2}_illumina_norm.vcf ${2}_illumina.vcf.gz

# Temporary sed script
sedScript=$(mktemp)

# Build sed script from samples.txt
while IFS=$'\t' read -r pattern replacement; do
    # Escape any sed-special characters in pattern and replacement
    safe_pattern=$(printf '%s\n' "$pattern" | sed 's/[&/\|]/\\&/g')
    safe_replacement=$(printf '%s\n' "$replacement" | sed 's/[&/\|]/\\&/g')

    echo "s|$safe_pattern|$safe_replacement|g" >> "$sedScript"
done < ../samples.txt

# Apply all substitutions in one go
sed -i -f "$sedScript" "${2}_nanopore_norm.vcf"

# Clean up
rm "$sedScript"

# More substitutions
sed -i "s#/scratch/36471977/2_indelRealigned/##g;s#_q20##g;s#_q10##g;s#_realigned.bam##g;s#_markDups.bam##g" ${1}_nanopore_norm.vcf
sed -i "s#/scratch/36471977/2_indelRealigned/##g;s#_q20##g;s#_q10##g;s#_realigned.bam##g;s#_markDups.bam##g" ${1}_illumina_norm.vcf

echo "Job finised with exit code $? at: `date`"
