#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mem=10G

echo "starting run at: `date`"

scripts=/work/soghigian_lab/huiqing.yeo/pipiens/scripts/pipiens
#sbatch ${scripts}/create_scratchDir.slurm --output ${scripts}/slurm-%j.out

####### Set environment variables ###############
SCRATCH=/scratch/$SLURM_JOBID

cd ${SCRATCH}
mkdir placeholder

echo "SCRATCH directory created at: ${SCRATCH} on `date`"

echo "Job finised with exit code $? at: `date`"