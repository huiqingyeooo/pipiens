#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=7-00:00:00
#SBATCH --mem=500G
#SBATCH --partition=cpu2023
#SBATCH --output=slurm-b2_%j.out

####### Set environment variables ###############
PATH=/work/soghigian_lab/apps/ngsRelate:$PATH
PATH=/work/soghigian_lab/apps/angsd:$PATH

batchName=b2
filelist=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/symlinks/bam159.filelist
bams=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/symlinks
angsd=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b2_nominmaf_minInd128
#input=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b2_nominmaf_minInd128/plink
output=/work/soghigian_lab/huiqing.yeo/pipiens/9_ngsrelate

echo "starting run at: `date`"

####### Script ##################################

### First we generate a file with allele frequencies (angsdput.mafs.gz) and a file with genotype likelihoods (angsdput.glf.gz).
#cd ${bams}
#angsd -b ${filelist} -gl 2 -domajorminor 1 -snp_pval 1e-6 -domaf 1 -minmaf 0.05 -doGlf 3 -out ${angsd}/${batchName}_mm005
#echo "angsd done, generating freq file"

### Then we extract the frequency column from the allele frequency file and remove the header (to make it in the format NgsRelate needs)
#cd ${angsd}
#zcat ${batchName}_mm005.mafs.gz | cut -f5 |sed 1d > ${output}/${batchName}_mm005.freq
#echo "freq file generated, running ngsrelate"

### run NgsRelate
ngsRelate  -g ${angsd}/${batchName}_mm005.glf.gz -n 159 -f ${output}/${batchName}_mm005.freq -O ${output}/b2_mm005_angsd.res

echo "Job finised with exit code $? at: `date`"
