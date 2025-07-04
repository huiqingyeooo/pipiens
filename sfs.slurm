#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=100G
#SBATCH --output=slurm-sfs-%j.out 

####### Set environment variables ###############
# activate conda for angsd
#source ~/software/init-conda-sl
#conda activate /work/soghigian_lab/apps/conda/envs/angsd
PATH=/work/soghigian_lab/apps/angsd:$PATH
angsd_program=/work/soghigian_lab/apps/angsd
PATH=/home/huiqing.yeo/.cargo/bin/winsfs:$PATH
idx_folder=/work/soghigian_lab/huiqing.yeo/pipiens/6_fst/b3

# define variables
refGenome=/work/soghigian_lab/huiqing.yeo/pipiens/refGenome/pipiens/Cpip29_nodebris_gapfill.fasta
cd ${idx_folder}

#env PERL5LIB= PERL_LOCAL_LIB_ROOT= parallel sbatch sfs.slurm ::: pip.cal pip.edm pip.red
echo "starting run at: `date`"
echo "for population ${1}"
SCRATCH=/scratch/$SLURM_JOBID
echo "slurm job $SLURM_JOBID"

####### Script ##################################
# calculate per pop saf for each population
cd /work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/symlinks

# Construct site allele frequency likelihoods for each site (-dosaf) based on individual genotype likelihoods
# -dosaf 1 calculates SAF assuming Hardy Weinberg equilibrium. Used for estimating SFS assuming allele frequencies are in equilibrium with the population
# this will generate 3 binary files: 1) angsdput.saf.idx 2) angsdput.saf.pos.gz 3) angsdput.saf.gz
angsd -b ${idx_folder}/${1}.list -anc ${refGenome} -out ${idx_folder}/${1} -nThreads 16 \
-dosaf 1 -gl 1 -minMapQ 20 -minQ 30 -setMinDepthInd 3 -only_proper_pairs 1 -remove_bads 1 -uniqueOnly 1

# save number of sites in a text file
num=$(grep "Number of sites retained after filtering:" slurm-sfs-$SLURM_JOBID.out | awk '{print $NF}')
echo $num > ${1}.snps
grep "Number of sites retained after filtering:" slurm-sfs-$SLURM_JOBID.out >> ${1}.arg
echo "angsd for ${1} done"

# To find SFS use either angsd or winsfs
## realSFS in angsd runs, but does not give me an output (.ml)
# ${angsd_program}/misc/realSFS ${1}.saf.idx > ${1}.ml

## winsfs. Takes about ~10 minutes to run for 20 samples
winsfs ${idx_folder}/${1}.saf.idx > ${idx_folder}/${1}.sfs
echo "winsfs for ${1} done"

# removes intermediate files .saf.gz, .pos.gz, .saf.idx as the file sizes are big (especially .saf.gz)
# rm ${1}.saf.gz ${1}.saf.pos.gz ${1}.saf.idx

echo "Job finised with exit code $? at: `date`"
