#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=10:00:00
#SBATCH --mem=20G

####### Set environment variables ###############
PATH=/work/soghigian_lab/apps/samtools-1.15/bin:$PATH

# activate conda for picard and gatk3
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/picard

# scratch dir
scratchDir=/scratch/45624817
projDir=${scratchDir}/1_alignedReads
mappedReads=${scratchDir}/1_alignedReads
scripts=/work/soghigian_lab/huiqing.yeo/pipiens/scripts/pipiens

# loop code
cd ${mappedReads}
#for file in $(ls ${mappedReads}/*_q20_sorted.bam);
#do
#taxa=$(basename $file _q20_sorted.bam)
#echo ${taxa}
#cd ${scripts}
#sed "s/TEMPLATE/${taxa}/g" index_TEMPLATE.slurm > ${projDir}/index_${taxa}.slurm
#sbatch --output ${projDir}/slurm-%j.out ${projDir}/index_${taxa}.slurm
#sleep 1
#done

echo "starting run at: `date`"

#########################################
#### Script 
#########################################

echo "Building bam index for sample_TEMPLATE"
picard BuildBamIndex I=TEMPLATE_q20_sorted.bam O=TEMPLATE_q20_sorted.bai
#picard BuildBamIndex I=TEMPLATE_markDups.bam O=TEMPLATE_markDups.bai

echo "Job finised with exit code $? at: `date`"